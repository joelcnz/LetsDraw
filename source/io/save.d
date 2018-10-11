module io.save;

import base;

struct Save {
    auto save(string fileName) {
        import core.stdc.stdio;
        import std.path: buildPath;
        import std.string;

        //fileName = buildPath("saves", fileName ~ ".bin");
        FILE* f;
        if ((f = fopen(fileName.toStringz, "wb")) == null) {
            jx.addToHistory("save: '", fileName, "' can't be opened");

            return false;
        }
        scope(exit)
            fclose(f);
        ubyte ver = 1;
        fwrite(&ver, 1, ubyte.sizeof, f); // 1 version

        return true;
    }
}
