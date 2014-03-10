// Generated by CoffeeScript 1.7.1
var SL, _ref;

SL = (_ref = window.SL) != null ? _ref : {};

Client.prototype.load = function() {
  var CELLSHEET_DESCRIPTIONS, FONTSHEET_DESCRIPTIONS, SPRITE_DESCRIPTIONS, description, index, _i, _j, _k, _len, _len1, _len2, _results;
  SPRITE_DESCRIPTIONS = ['irrelon.png'];
  CELLSHEET_DESCRIPTIONS = [];
  FONTSHEET_DESCRIPTIONS = [];
  for (_i = 0, _len = SPRITE_DESCRIPTIONS.length; _i < _len; _i++) {
    description = SPRITE_DESCRIPTIONS[_i];
    index = description.split('.')[0].replace(/(\/|\\)/g, '');
    SL.tex[index] = new IgeTexture(SL.SPRITE_DIRECTORY + description);
  }
  for (_j = 0, _len1 = CELLSHEET_DESCRIPTIONS.length; _j < _len1; _j++) {
    description = CELLSHEET_DESCRIPTIONS[_j];
    index = description[0].split('.')[0].replace(/(\/|\\)/g, '');
    SL.tex[index] = new IgeCellSheet(SL.SPRITE_DIRECTORY + description[0], description[1], description[2]);
  }
  _results = [];
  for (_k = 0, _len2 = FONTSHEET_DESCRIPTIONS.length; _k < _len2; _k++) {
    description = FONTSHEET_DESCRIPTIONS[_k];
    index = description.split(".")[0].replace(/(\/|\\)/g, '');
    _results.push(SL.font[index] = new IgeFontSheet(SL.FONTSHEET_DIRECTORY + description));
  }
  return _results;
};