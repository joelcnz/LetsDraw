//#test
module io.load;

import base;

struct Load {
    bool load(string fileName, in string[] types) {
        import core.stdc.stdio;
        import std.path: buildPath;
        import std.string;
        import std.algorithm.searching: canFind;

        bool onlyPushers = types.canFind("@onlyPushers");

        FILE* f;
        if ((f = fopen(fileName.toStringz, "rb")) == null) {
            jx.addToHistory("load: '", fileName, "' can't be opened");

            return false;
        }
        scope(exit)
            fclose(f);
        ubyte ver;
        fread(&ver, 1, ubyte.sizeof, f); // 1 version

        switch(ver) {
            default: jx.addToHistory("Unknown version - ", ver); break;
            case 1:
            break;
            case 2:
            break;
        } // switch

        return true;
    }
}
