(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
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

},{"./lib/jp-wrap":3}],2:[function(require,module,exports){
module.exports = {
  "Opening brackets": "‘“（〔［｛〈《「『【｟〘〖«〝＜",
  "Opening brackets ASCII": "([{<",
  "Opening brackets HANKAKU": "｢",
  "Closing brackets": "’”）〕］｝〉》」』】｠〙〗»〟＞",
  "Closing brackets ASCII": ")]}>",
  "Closing brackets HANKAKU": "｣",
  "Hyphens": "‐〜゠–－～",
  "Hyphens ASCII": "-~",
  "Dividing punctuation marks": "！？‼⁇⁈⁉",
  "Dividing punctuation marks ASCII": "!?",
  "Middle dots": "・：；",
  "Middle dots ASCII": ":;",
  "Middle dots HANKAKU": "･",
  "Full stops": "。．",
  "Full stops ASCII": ".",
  "Full stops HANKAKU": "｡",
  "Commas": "、，",
  "Commas ASCII": ",",
  "Commas HANKAKU": "､",
  "Inseparable characters": "—―…‥",
  "Inseparable characters sets": ["〳〵", "〴〵"],
  "Iteration marks": "ヽヾゝゞ々〻",
  "Prolonged sound mark": "ー",
  "Prolonged sound mark HANKAKU": "ｰ",
  "Small kana": "ぁぃぅぇぉァィゥェォっゃゅょゎゕゖッャュョヮヵヶㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ",
  "Small kana HANKAKU": "ｧｨｩｪｫｬｭｮｯ",
  "Prefixed abbreviations": "¥＄£€¤₩￡￥￦" + "№＃",
  "Prefixed abbreviations ASCII": "\\$" + "#",
  "Prefixed abbreviations KANJI": "",
  "Postfixed abbreviations": "°′″℃％‰‱ℓ℉ℊΩKÅ" + "\\u3300-\\u3377\\u3371-\\u337A\\u3380-\\u33DF" + "¢￠",
  "Postfixed abbreviations ASCII": "%",
  "Postfixed abbreviations KANJI": "",
  "Full-width ideographic space": "　",
  "Hiragana": "\\u3041-\\u3096",
  "Katakana": "\\u30A1-\\u30FA",
  "Math symbols": "＋−×÷±∓－",
  "Math symbols ASCII": "+-",
  "Grouped numerals": "　，．０１２３４５６７８９",
  "Grouped numerals ASCII": " ,.0123456789",
  "Unit symbols": "　（）／１−４Ａ-Ｚａ-ｚΩμ℧Å−・",
  "Unit symbols ASCII": " ()/1234" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "abcdefghijklmnopqrstuvwxyz",
  "Western word space": "\\u0020",
  "Western characters": "\\u0021-\\u007E\\u00A0-\\u1FFF",
  "Warichu opening brackets": "（〔［",
  "Warichu opening brackets ASCII": "([",
  "Warichu closing brackets": "）〕］",
  "Warichu closing brackets ASCII": ")]"
};

},{}],3:[function(require,module,exports){
var JpWrap, Regexps, Word;

Word = require('./word');

Regexps = require('./regexps');


/**
日本語の禁則処理を行って改行する

@class JpWrap
@module jp-wrap
 */

JpWrap = (function() {
  JpWrap.prototype.DEFAULT_WIDTH = 100;

  JpWrap.notStartingCharRegExp = Regexps.notStartingChars;

  JpWrap.notStartingCharWithHalfRegExp = Regexps.notStartingCharsWithHalf;

  JpWrap.notEndingCharRegExp = Regexps.notEndingChars;


  /**
  @constructor
  @param {Number} [width=100] 半角1, 全角2としたときの全体の幅
  @param {Object} [options]
  @param {Boolean} [options.half] 半角文字の行頭禁則処理を行うか
  @param {Boolean} [options.trim=true] 入力文字列の改行を取り除くかどうか
  @param {Boolean} [options.breakAll] trueだとcssのword-break:break-allと同じ挙動をする
  @param {Boolean} [options.fullWidthSpace=true] 全角スペースが行頭にあった場合削除するか
  @param {Boolean} [options.sameWidth] 全角文字と半角文字の幅を両方とも2として計算する
  @param {Object} [options.regexs] 幅の計算方法を正規表現で指定する
   */

  function JpWrap(width, options) {
    var ref, ref1, ref2;
    this.width = width != null ? width : this.DEFAULT_WIDTH;
    if (options == null) {
      options = {};
    }
    this.trim = !!((ref = options.trim) != null ? ref : true);
    this.breakAll = !!options.breakAll;
    this.half = !!options.half;
    this.fullWidthSpace = !!((ref1 = options.fullWidthSpace) != null ? ref1 : true);
    this.regexs = (ref2 = options.regexs) != null ? ref2 : [];
    this.sameWidth = !!options.sameWidth;
  }


  /**
  textを分割し、行(String)の配列を取得
  
  @method wrap
  @public
  @param {String} text
  @return {Array(String)} lines 分割された行の配列
   */

  JpWrap.prototype.wrap = function(text) {
    var i, len, line, ref, results;
    ref = this.getLines(text);
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      results.push(line.str);
    }
    return results;
  };


  /**
  textを分割し、行(Wordオブジェクト)の配列を取得
  戦略：文字列を単語ごとに分解してから、行を埋めていく
  
  @method getLines
  @public
  @param {String} text
  @return {Array(String)} lines 分割された行の配列
   */

  JpWrap.prototype.getLines = function(text) {
    var currentLine, i, len, lines, word, words;
    lines = [];
    words = this.splitTextIntoWords(text);
    currentLine = null;
    for (i = 0, len = words.length; i < len; i++) {
      word = words[i];
      if (currentLine == null) {
        currentLine = word.ltrim(this.fullWidthSpace);
      } else if (currentLine.hasLineBreak()) {
        lines.push(currentLine);
        currentLine = word.ltrim(this.fullWidthSpace);
      } else if (currentLine.width + word.width <= this.width) {
        currentLine.append(word);
      } else {
        lines.push(currentLine);
        currentLine = word.ltrim(this.fullWidthSpace);
      }
    }
    if (currentLine.hasStr()) {
      lines.push(currentLine);
    }
    return lines;
  };


  /**
  与えられた文字列を単語に分割
  行頭に来ることができないものを前の文字の続きにして分割
  
  @method splitTextIntoWords
  @private
  @param {String} text
  @return {Array(Word)}
   */

  JpWrap.prototype.splitTextIntoWords = function(text) {
    var c, currentWord, i, len, word, words;
    words = [];
    currentWord = new Word('', {
      sameWidth: this.sameWidth,
      regexs: this.regexs
    });
    for (i = 0, len = text.length; i < len; i++) {
      c = text[i];
      if (c === '\n') {
        if (!this.trim) {
          words.push(currentWord.appendLineBreak(c));
          currentWord = new Word();
        }
        continue;
      }
      word = new Word(c, {
        sameWidth: this.sameWidth,
        regexs: this.regexs
      });
      if (this.isJoinable(currentWord, word)) {
        currentWord.append(word);
      } else {
        if (currentWord.hasStr()) {
          words.push(currentWord);
        }
        currentWord = word;
      }
    }
    if (currentWord.hasStr()) {
      words.push(currentWord);
    }
    return words;
  };


  /**
  word1にword2をjoinしていいのかどうか
  @method isJoinable
  @private
  @param {Word} word1
  @param {Word} word2
   */

  JpWrap.prototype.isJoinable = function(word1, word2) {
    var ref, regex;
    if (word1.width + word2.width > this.width) {
      return false;
    }
    if ((ref = word1.last()) != null ? ref.match(this.constructor.notEndingCharRegExp) : void 0) {
      return true;
    }
    if (this.breakAll) {
      return false;
    }
    if (word1.isAlphaNumeric && word2.isAlphaNumeric) {
      return true;
    }
    regex = this.half ? this.constructor.notStartingCharWithHalfRegExp : this.constructor.notStartingCharRegExp;
    return !!word2.str.match(regex);
  };

  return JpWrap;

})();

module.exports = JpWrap;

},{"./regexps":4,"./word":5}],4:[function(require,module,exports){
var CharacterClasses;

CharacterClasses = require('./character-classes');

module.exports = {
  notStartingChars: new RegExp(['[', CharacterClasses['Closing brackets'], CharacterClasses['Hyphens'], CharacterClasses['Dividing punctuation marks'], CharacterClasses['Middle dots'], CharacterClasses['Full stops'], CharacterClasses['Commas'], CharacterClasses['Iteration marks'], CharacterClasses['Prolonged sound mark'], CharacterClasses['Small kana'], ']'].join('')),
  notEndingChars: new RegExp(['[', CharacterClasses['Opening brackets'], ']'].join('')),
  notStartingCharsHalf: new RegExp(['[', CharacterClasses['Closing brackets'], CharacterClasses['Hyphens'], CharacterClasses['Dividing punctuation marks'], CharacterClasses['Middle dots'], CharacterClasses['Full stops'], CharacterClasses['Commas'], CharacterClasses['Iteration marks'], CharacterClasses['Prolonged sound mark'], CharacterClasses['Small kana'], CharacterClasses['Closing brackets HANKAKU'], CharacterClasses['Middle dots HANKAKU'], CharacterClasses['Full stops HANKAKU'], CharacterClasses['Commas HANKAKU'], CharacterClasses['Prolonged sound mark HANKAKU'], CharacterClasses['Small kana HANKAKU'], ']'].join(''))
};

},{"./character-classes":2}],5:[function(require,module,exports){

/**
文字 str とその幅 width を持つオブジェクト

@class Word
@module jp-wrap
 */
var Word;

Word = (function() {

  /**
  @constructor
  @param {String} str
  @param {Boolean} [options.sameWidth] 全角文字と半角文字の幅を両方とも2として計算する
  @param {Object} [options.regexs] 幅の計算方法を正規表現で指定する
   */
  function Word(str1, options) {
    var ref;
    this.str = str1 != null ? str1 : '';
    if (options == null) {
      options = {};
    }
    this.sameWidth = !!options.sameWidth;
    this.regexs = (ref = options.regexs) != null ? ref : [];
    this.width = this.constructor.widthByStr(this.str, {
      sameWidth: this.sameWidth,
      regexs: this.regexs
    });
    this.isAlphaNumeric = !!(this.str.match(/\w$/));
    this.lbStr = null;
  }


  /**
  最後の文字を取得
  
  @method last
  @return {String} lastChar
   */

  Word.prototype.last = function() {
    return this.str[this.str.length - 1];
  };


  /**
  頭のスペースを取り除く 全角文字も取り除く場合は第1引数をtrueに
  
  @method ltrim
  @param {Boolean} fullWidths 全角スペースも取り除く
  @return {Word} this
   */

  Word.prototype.ltrim = function(fullWidthSpace) {
    var matched, regex;
    if (fullWidthSpace == null) {
      fullWidthSpace = false;
    }
    regex = fullWidthSpace ? /^([\s\u3000]+)/ : /^( +)/;
    if (matched = this.str.match(regex)) {
      this.str = this.str.slice(matched[1].length);
      this.width -= this.constructor.widthByStr(matched[1], {
        sameWidth: this.sameWidth,
        regexs: this.regexs
      });
    }
    return this;
  };


  /**
  与えられたWordを末尾に追加
  
  @method append
  @public
  @param {Word} word
  @return {Word} this
   */

  Word.prototype.append = function(word) {
    if (this.hasLineBreak()) {
      throw new Error('hasLineBreak');
    }
    this.str += word.str;
    this.width += word.width;
    this.isAlphaNumeric = word.isAlphaNumeric;
    this.lbStr = word.lbStr;
    return this;
  };


  /**
  与えられた文字列を末尾に追加
  
  @method append
  @public
  @param {String} str
  @return {Word} this
   */

  Word.prototype.appendText = function(str) {
    return this.append(new Word(str));
  };


  /**
  改行文字を末尾に追加
  
  @method appendLineBreak
  @return {Word} this
   */

  Word.prototype.appendLineBreak = function(lbStr) {
    this.lbStr = lbStr;
    this.isAlphaNumeric = false;
    return this;
  };


  /**
  文字を含むかどうか
  
  @method hasStr
  @public
  @return {Boolean}
   */

  Word.prototype.hasStr = function() {
    return this.str.length > 0;
  };


  /**
  改行文字を(末尾に)含むかどうか
  
  @method hasLineBreak
  @public
  @return {Boolean}
   */

  Word.prototype.hasLineBreak = function() {
    return this.lbStr != null;
  };


  /**
  文字列の幅を計算
  現時点ではASCIIおよび半角カタカナ以外の半角は認識できない
  全角文字と半角文字の幅を両方とも2として計算する場合はsameWidthオプションをtrueに
  正規表現で指定した文字の幅を指定して計算する場合はregexsオプションにpatternとwidthを持ったオブジェクトの配列を渡す
  
  @method widthByStr
  @private
  @static
   */

  Word.widthByStr = function(str, options) {
    var c, fullWidths, i, j, len, len1, length, matched, ref, regexInfo, regexs, sameWidth;
    if (str == null) {
      str = '';
    }
    if (options == null) {
      options = {};
    }
    sameWidth = !!options.sameWidth;
    regexs = (ref = options.regexs) != null ? ref : [];
    if (sameWidth) {
      return str.length * 2;
    } else if (Array.isArray(regexs) && regexs.length > 0) {
      length = 0;
      for (i = 0, len = str.length; i < len; i++) {
        c = str[i];
        matched = false;
        for (j = 0, len1 = regexs.length; j < len1; j++) {
          regexInfo = regexs[j];
          if (c.match(regexInfo.pattern)) {
            length += regexInfo.width;
            matched = true;
            break;
          }
        }
        if (!matched) {
          length += 2;
        }
      }
      return length;
    } else {
      fullWidths = ((function() {
        var k, len2, results;
        results = [];
        for (k = 0, len2 = str.length; k < len2; k++) {
          c = str[k];
          if (!c.match(this.halfWidthRegex)) {
            results.push(c);
          }
        }
        return results;
      }).call(this)).length;
      return fullWidths + str.length;
    }
  };


  /**
  ASCII文字と半角カタカナにマッチする正規表現
  
  @property {RegExp} halfWidthRegex
  @private
  @static
   */

  Word.halfWidthRegex = new RegExp('[ -~\uFF61-\uFF64\uFF65-\uFF9F]');

  return Word;

})();

module.exports = Word;

},{}],6:[function(require,module,exports){
window.jpWrap = require('../dist/jp-wrap-entry');

},{"../dist/jp-wrap-entry":1}]},{},[6]);
