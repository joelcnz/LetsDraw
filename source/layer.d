//#not work!
module layer;

import base;

struct Layer {
    Image _img;
    Texture _texture;
    Sprite _sprite;

    void setup() {
        _img = new Image();
        _img.create(SCREEN_W, SCREEN_H, Color(0,0,0,0));
        _texture = new Texture;
        _sprite = new Sprite;
    }

    void drawDot(Pointi pos, Color colour) {
        _img.setPixel(pos.X, pos.Y, colour);
    }

    void draw() {
        _texture.loadFromImage(_img);
        _sprite.setTexture(_texture);
        g_window.draw(_sprite);
    }
}