module base;

public:
import dsfml.window;
import dsfml.graphics;
import dsfml.audio;

import jec, dini.dini, jmisc;

import std.stdio, std.conv, std.range, std.string, std.path, std.file;

import historyman;
import io;

Setup g_setup;

alias jx = g_inputJex;

enum UserMode {mainMode, terminalMode}
UserMode g_userMode;

immutable SCREEN_W = 800, SCREEN_H = 600;

HistoryMan g_historyMan;

static this() {
}
