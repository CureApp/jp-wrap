var JpWrap, entry;

JpWrap = require('./lib/jp-wrap');


/**
[substack/node-wordwrap](https://github.com/substack/node-wordwrap)とほぼ同じAPIに
https://github.com/substack/node-wordwrap/blob/master/LICENSE
copyright

@param {Number} start 単独で指定した場合、文字列の幅。この場合第2引数がoptionsとして扱われる
@param {Number} [stop] 指定された場合、`stop - start`の幅で行い、左右にstartだけのpaddingをつける
@param {Object} [options]
@param {Boolean} [options.half] 半角文字の行頭禁則処理を行うか
@param {Boolean} [options.trim=false] 入力文字列の改行を取り除くかどうか
@param {Boolean} [options.breakAll] trueだとcssのword-break:break-allと同じ挙動をする
@param {Boolean} [options.fullWidthSpace=true] 全角スペースが行頭にあった場合削除するか
@param {Boolean} [options.sameWidth] 全角文字と半角文字の幅を両方とも2として計算する
@return {String} 整形された文字列
 */

entry = function(start, stop, options) {
  var i, jpWrap, spaces, spacesStart;
  if (options == null) {
    options = {};
  }
  if (options.trim == null) {
    options.trim = false;
  }
  if (typeof stop === 'object') {
    options = stop;
    stop = null;
  }
  if (!stop) {
    jpWrap = new JpWrap(start, options);
    return function(text) {
      return jpWrap.wrap(text).join('\n');
    };
  }
  jpWrap = new JpWrap(stop - start, options);
  spaces = ((function() {
    var j, ref, results;
    results = [];
    for (i = j = 0, ref = stop; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
      results.push(' ');
    }
    return results;
  })()).join('');
  spacesStart = spaces.slice(0, start);
  return function(text) {
    var line, lines;
    lines = (function() {
      var j, len, ref, results;
      ref = jpWrap.getLines(text);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        line = ref[j];
        results.push(spacesStart + line.str + spaces.slice(0, stop - line.width));
      }
      return results;
    })();
    return lines.join('\n');
  };
};

module.exports = entry;

module.exports.JpWrap = JpWrap;
