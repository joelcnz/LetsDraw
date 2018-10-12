module layerman;

import base;

struct LayerMan {
    Layer[] _layers;

    void add() {
        _layers ~= Layer();
        _layers[$ - 1].setup;
    }

    void draw() {
        foreach(layer; _layers) {
            layer.draw;
        }
    }
}