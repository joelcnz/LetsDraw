module pointer;

import base;

struct Pointer {
    int _layer;
    Pointi _pos;
    Color _colour;

    void setup() {
        _layer = 0;
        _colour = Color(255, 180, 0);
    }

    void updatePos() {
        auto pos = Mouse.getPosition(g_window);
        _pos = Pointi(pos.x, pos.y);
    }

    void drawDot() {
        if (_layer == -1)
            return;
        g_layerMan._layers[_layer].drawDot(_pos, _colour);
    }
}