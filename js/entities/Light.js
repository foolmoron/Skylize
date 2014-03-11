// Generated by CoffeeScript 1.7.1
var Light;

Light = IgeEntity.extend({
  classId: 'Light',
  init: function(_type) {
    this._type = _type;
    IgeEntity.prototype.init.call(this);
    return this.color(Light.COLOR.WHITE).dimensionsFromCell();
  },
  color: function(color) {
    if (color === void 0) {
      return this._color;
    }
    this._color = color;
    this.texture(SL.tex[this._type + this._color]);
    return this;
  }
});

Light.TYPE = {
  SIDE: 'side',
  DIAG: 'diag',
  MID: 'mid'
};

Light.COLOR = {
  WHITE: 'w',
  RED: 'r',
  GREEN: 'g',
  BLUE: 'b',
  PINK: 'p',
  YELLOW: 'y'
};

if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
  module.exports = Light;
}
