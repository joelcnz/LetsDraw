// see layer.d void draw
/+
Welcome to Lets Draw!
+/

module main;

//version = Test;

import std.math;

import base;

int main(string[] args) {
	scope(exit)
		"\n###\n#  #\n#  #\n#  #\n###\n".writeln;
    g_window = new RenderWindow(VideoMode(SCREEN_W, SCREEN_H),
							  "Welcome to Lets-Draw! Press [System] + [Q] to quit"d);

	if (g_setup.setup != 0) {
		gh("Setup error, aborting...");
		g_window.close;

		return -1;
	}

	g_font = new Font;
	g_font.loadFromFile("Fonts/DejaVuSans.ttf");
	if (! g_font) {
		import std.stdio;
		writeln("Font not load");
		return -1;
	}

	scope(exit)
		g_setup.shutdown;

	g_historyMan.add("Welcome to Lets-Draw");

	JSound saveSound;
	import std.path;
	saveSound = new JSound(buildPath("Audio", "snapshot.wav"));

	g_window.setFramerateLimit(60);

	import std.datetime.stopwatch: StopWatch;
	StopWatch timer;
	timer.start;

	string[] files = cat(/* display: */ false);

	g_layerMan.add;

	Pointer pntr;
	pntr.setup;

    while(g_window.isOpen())
    {
        Event event;

        while(g_window.pollEvent(event))
        {
            if(event.type == event.EventType.Closed)
            {
                g_window.close();
            }
        }

		if ((Keyboard.isKeyPressed(Keyboard.Key.LSystem) || Keyboard.isKeyPressed(Keyboard.Key.RSystem)) &&
			Keyboard.isKeyPressed(Keyboard.Key.Q)) {
			g_window.close;
		}

		bool jXProcess(in dstring input) {
			void displayHelp() {
				jx.addToHistory("t - return to main editing");
				jx.addToHistory("cat - list project files");
				jx.addToHistory("save <file name>");
				jx.addToHistory("load (@onlyPushers) <file name>");
				jx.addToHistory("delete <file name>");
			}
			if (! input.length) {
				displayHelp;
				return false;
			}

			import std.ascii: isDigit;
			import std.string: split, join;
			import std.algorithm: startsWith, acountUntil = countUntil;
			import std.path: setExtension;

			string news = input.to!string;
			string command = news.split[0];
			//#work here
			auto args = news.split[1 .. $];

			auto pos = news.acountUntil(" ");
			if (pos == -1)
				pos = 0;
			string forQuotes = news[pos .. $] ~ " ";
			forQuotes.gh;
			args.length = 0;
			int i, qsp, wsp;
			bool inQuotes, inWord;
			while(i < forQuotes.length) {
				// save 0 @onlyPushers
				// to ["0", "@onlyPushers"]
				/+
				+/
				//quotes:
				if (! inWord && forQuotes[i] == '"') {
					if (! inQuotes) {
						inQuotes = true;
						qsp = i + 1;
					} else if (inQuotes) {
						args ~= forQuotes[qsp .. i];
						inQuotes = false;
					}
				}
				//word:
				if (! inQuotes) {
					if (inWord) {
						if (forQuotes[i] == ' ') {
							args ~= forQuotes[wsp .. i];
							inWord = false;
						}
					}
					if (! inWord && forQuotes[i] != ' ' && forQuotes[i] != '"') {
						wsp = i;
						inWord = true;
					}
				}
				i += 1;
			}

			string[] types;
			string values;
			foreach(arg; args)
				if (arg.startsWith("@"))
					types ~= arg;
				else
					values ~= arg ~ " ";
			if (values.length)
				values = values[0 .. $ - 1]; // remove the space at the end
			string fileName = buildPath("saves", values.setExtension(".bin"));

			string someException() {
				import std.conv: text;

				return text(command, " ", values, " - some exception");
			}

			try {
				import std.string: strip;

				writeln(values);
				if (values.length) {
					auto svalue = values.strip;
					writeln(svalue);
					if (svalue[0].isDigit)
						mixin(jecho("fileName = files[svalue.to!int];"));
				}
			} catch(Exception e) {
				writeln(someException);
			}

			switch(command) {
				default:
				case "help":
					displayHelp;
					jx.addToHistory("Help displayed..");
				break;
				case "cat":
					files = cat(/* display: */ true);
				break;
				case "save":
					Save s;
					if (s.save(fileName))
						jx.addToHistory("Saved: ", fileName);
				break;
				case "load":
					Load l;
					if (l.load(fileName, types))
						jx.addToHistory("Loaded: ", fileName, " ", types);
				break;
				//#rename
				case "rename":

				break;
				case "delete":
					bool yes;
					if (! fileName.exists)
						jx.addToHistory(fileName, " not exist!");
					else {
						jx.addToHistory("Delete ", fileName, " are you sure Y/N?");
						g_window.clear;
						jx.draw;
						g_window.display;
						bool doneYN;
						do {
							while(g_window.pollEvent(event))
							{ }
							if (g_keys[Keyboard.Key.N].keyInput || g_keys[Keyboard.Key.Escape].keyInput)
								yes = false,
								doneYN = true;
							if (g_keys[Keyboard.Key.Y].keyInput)
								yes = true,
								doneYN = true;
						} while(! doneYN);
					}
					if (! yes) {
						jx.addToHistory("File deletion canceled");
						break;
					}
					try {
						remove(fileName);
					} catch(Exception e) {
						jx.addToHistory(fileName, " - some exception");
						break;
					}
					jx.addToHistory(fileName, " - deleted");
				break;
				case "t":
					g_userMode = UserMode.mainMode;
					g_historyMan.add("Terminal off..");
				break;
			}

			return true;
		}

		final switch(g_userMode) with(UserMode) {
			case mainMode:
				if (g_keys[Keyboard.Key.T].keyInput) {
					g_userMode = UserMode.terminalMode;
					g_historyMan.add("Terminal on..");
				}
				if (g_keys[Keyboard.Key.A].keyInput) {
					g_historyMan._all = ! g_historyMan._all;
				}
				if (Keyboard.isKeyPressed(Keyboard.Key.V)) {
					pntr.drawDot;
				}
			break;
			case terminalMode:
				jx.process; //#input
				if (g_inputJex.enterPressed) {
					jx.enterPressed = false;
					jXProcess(jx.textStr);
					jx.textStr = "";
				}
			break;
		} // switch

	version(Test) {
		static tpos = Pointi(0,15);
		layerMan._layers[0].drawDot(tpos, Color.Red);
		tpos += Pointi(1, 0);
		if (tpos.X == SCREEN_W)
			tpos = Pointi(0, tpos.Y + 1);
	}

		pntr.updatePos;

		g_window.clear;

		final switch(g_userMode) with (UserMode) {
			case mainMode:
				g_layerMan.draw;
				g_historyMan.draw;
			break;
			case terminalMode:
				jx.draw;
			break;
		}

    	g_window.display;
    }
	
	return 0;
}

auto cat(bool display) {
	import std.algorithm: find, until, sort;
	import std.conv: text;
	import std.file: dirEntries, DirEntry, SpanMode;
	import std.path: dirSeparator;
	import std.range: enumerate;
	import std.array: array, replicate;

	if (display)
		jx.addToHistory("File list from 'Saves':");
	int i;
	string[] files;
	foreach(DirEntry file; dirEntries("Saves", "*.{bin}", SpanMode.shallow).array.sort!"a.name < b.name") {
		files ~= file.name.idup;
		if (display) {
			auto name = file.name.find(dirSeparator)[1 .. $].until(".").array;
			jx.addToHistory(text(i++, ") ", name, " ".replicate(14 - name.length), file.size, " bytes"));
		}
	}

	return files;
}
