// Generated by CoffeeScript 1.7.1
var Client, SL, _ref;

SL = window.SL = (_ref = window.SL) != null ? _ref : {};

SL.GOOGLE_API_KEY = "AIzaSyClmp-OcgOFVF9fPybWuFAutXOlYr7PAl8";

SL.SPRITE_DIRECTORY = "./sprites/";

SL.FONTSHEET_DIRECTORY = "./font/";

SL.AUDIO_DIRECTORY = "./audio/";

SL.GRID_SIZE = 15;

SL.TILE_SIZE = 48;

SL.tex = {};

SL.font = {};

Client = IgeClass.extend({
  classId: 'Client',
  init: function() {
    ige.globalSmoothing(true);
    ige.on('texturesLoaded', (function(_this) {
      return function() {
        ige.createFrontBuffer(true);
        return ige.start(function(success) {
          var longString, urlParameter, _ref1;
          if (success) {
            $.ajaxSetup({
              async: false,
              contentType: 'application/json',
              processData: false
            });
            ige.viewportDepth(true);
            _this.setupScene();
            _this.setupEntities();
            if (((_ref1 = document.referrer.split("?")[1]) != null ? _ref1.length : void 0) > 0) {
              urlParameter = document.referrer.split("?")[1];
            }
            if (!urlParameter) {
              if (location.search.length > 0) {
                urlParameter = location.search.split("?")[1];
              }
            }
            if (urlParameter) {
              if (urlParameter[0] === 'l') {
                longString = urlParameter.substring(2);
              }
              if (urlParameter[0] === 's') {
                longString = _this.convertToLongString(urlParameter.substring(2));
              }
              if ((longString != null ? longString.length : void 0) > 0) {
                return _this.grid.deserialize(longString);
              }
            }
          }
        });
      };
    })(this));
    return this.load();
  },
  setupScene: function() {
    this.mainScene = new IgeScene2d().id('mainScene');
    this.vpMain = new IgeViewport().id('vpMain').autoSize(true).scene(this.mainScene).drawBounds(false).drawBoundsData(false).mount(ige);
    this.bgScene = new IgeScene2d().id('bgScene').layer(1).translateTo(0, 0, 0).mount(this.mainScene);
    this.gameScene = new IgeScene2d().id('gameScene').layer(2).translateTo(0, 0, 0).mount(this.mainScene);
    this.fgScene = new IgeScene2d().id('fgScene').layer(3).translateTo(0, 0, 0).mount(this.mainScene);
    this.vpMain._oldResizeEvent = this.vpMain._resizeEvent;
    this.vpMain._resizeEvent = (function(_this) {
      return function(event) {
        _this.vpMain._oldResizeEvent.call(_this.vpMain, event);
        return _this._resizeEvent.call(_this);
      };
    })(this);
    return this.vpMain._resizeEvent();
  },
  setupEntities: function() {
    this.grid = new Grid(SL.GRID_SIZE, SL.TILE_SIZE).id('grid').translateTo(-(SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, -(SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, 0).mount(this.gameScene);
    this.saveShareButton = new IgeUiEntity().texture(SL.tex['saveshare']).dimensionsFromCell().top(5).right(10).mouseDown((function(_this) {
      return function() {
        var longString, shortString;
        longString = _this.grid.serialize();
        shortString = _this.convertToShortString(longString);
        if (shortString) {
          return prompt("Use this URL to share you art with others, or bookmark it to come back later:", "http://foolmoron.itch.io/skylize?s=" + shortString);
        } else {
          return prompt("Something went wrong with the URL shortener, so you can't have a URL to share.  But you can use this monstrous URL to come back to your art later, if you want:", "http://foolmoron.itch.io/skylize?l=" + longString);
        }
      };
    })(this)).mount(this.fgScene);
    return this.clearButton = new IgeUiEntity().texture(SL.tex['clear']).dimensionsFromCell().top(5).left(10).mouseDown((function(_this) {
      return function() {
        if (confirm("Really clear the screen?")) {
          return _this.grid.clear();
        }
      };
    })(this)).mount(this.fgScene);
  },
  convertToLongString: function(shortString) {
    var longUrl;
    longUrl = null;
    $.get("https://www.googleapis.com/urlshortener/v1/url?key=" + SL.GOOGLE_API_KEY + "&shortUrl=http://goo.gl/" + shortString, function(data) {
      return longUrl = data.longUrl;
    });
    if ((longUrl != null) && longUrl.split('?l=').length > 0) {
      return longUrl.split('?l=')[1];
    }
  },
  convertToShortString: function(longString) {
    var shortUrl;
    shortUrl = null;
    $.post("https://www.googleapis.com/urlshortener/v1/url?key=" + SL.GOOGLE_API_KEY, '{"longUrl": "http://foolmoron.itch.io/skylize?l=' + longString + '"}', function(data) {
      return shortUrl = data.id;
    });
    if (shortUrl != null) {
      return shortUrl.split('/')[shortUrl.split('/').length - 1];
    }
  },
  _resizeEvent: function() {
    var windowWidth, _ref1, _ref2;
    if (!this.vpMain.resizing) {
      windowWidth = (_ref1 = (_ref2 = window.innerWidth) != null ? _ref2 : document.documentElement.clientWidth) != null ? _ref1 : d.getElementsByTagName('body')[0].clientWidth;
      if (windowWidth <= 740) {
        this.vpMain.resizing = true;
        this.vpMain.minimumVisibleArea(740, 700);
        return this.vpMain.resizing = false;
      } else {
        delete this.vpMain._lockDimension;
        return this.vpMain.scaleTo(1, 1, 1);
      }
    }
  }
});

if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
  module.exports = Client;
}
