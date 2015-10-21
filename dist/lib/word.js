
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
  @param {Boolean} sameWidth 全角文字と半角文字の幅を両方とも2として計算するか
   */
  function Word(str1, sameWidth1) {
    this.str = str1 != null ? str1 : '';
    this.sameWidth = sameWidth1 != null ? sameWidth1 : false;
    this.width = this.constructor.widthByStr(this.str, this.sameWidth);
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
      this.width -= this.constructor.widthByStr(matched[1], this.sameWidth);
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
  全角文字と半角文字の幅を両方とも2として計算する場合は第2引数をtrueに
  
  @method widthByStr
  @private
  @static
   */

  Word.widthByStr = function(str, sameWidth) {
    var c, fullWidths;
    if (str == null) {
      str = '';
    }
    if (sameWidth == null) {
      sameWidth = false;
    }
    if (sameWidth) {
      return str.length * 2;
    }
    fullWidths = ((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = str.length; i < len; i++) {
        c = str[i];
        if (!c.match(this.halfWidthRegex)) {
          results.push(c);
        }
      }
      return results;
    }).call(this)).length;
    return fullWidths + str.length;
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
