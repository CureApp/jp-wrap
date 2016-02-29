
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
