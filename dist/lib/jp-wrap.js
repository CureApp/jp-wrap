var CharacterClasses, JpWrap, Word,
  slice = [].slice;

CharacterClasses = require('./character-classes');

Word = require('./word');


/**
日本語の禁則処理を行って改行する

@class JpWrap
@module jp-wrap
 */

JpWrap = (function() {
  JpWrap.prototype.DEFAULT_WIDTH = 100;


  /**
  @constructor
  @param {Number} [width=100] 半角1, 全角2としたときの全体の幅
  @param {Object} [options]
  @param {Boolean} [options.half] 半角文字の行頭禁則処理を行うか
  @param {Boolean} [options.trim=true] 入力文字列の改行を取り除くかどうか
  @param {Boolean} [options.breakAll] trueだとcssのword-break:break-allと同じ挙動をする
  @param {Boolean} [options.fullWidthSpace=true] 全角スペースが行頭にあった場合削除するか
   */

  function JpWrap(width, options) {
    var ref, ref1, regexStr;
    this.width = width != null ? width : this.DEFAULT_WIDTH;
    if (options == null) {
      options = {};
    }
    this.trim = !!((ref = options.trim) != null ? ref : true);
    this.breakAll = !!options.breakAll;
    this.fullWidthSpace = !!((ref1 = options.fullWidthSpace) != null ? ref1 : true);
    regexStr = this.notStartingChars;
    if (options.half) {
      regexStr += this.notStartingCharsHalf;
    }
    this.notStartingCharRegExp = this.constructor.getRegexFromStrs(regexStr);
    this.notEndingCharRegExp = this.constructor.getRegexFromStrs(this.notEndingChars);
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
    currentWord = new Word();
    for (i = 0, len = text.length; i < len; i++) {
      c = text[i];
      if (c === '\n') {
        if (!this.trim) {
          words.push(currentWord.appendLineBreak(c));
          currentWord = new Word();
        }
        continue;
      }
      word = new Word(c);
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
    var ref;
    if (word1.width + word2.width > this.width) {
      return false;
    }
    if ((ref = word1.last()) != null ? ref.match(this.notEndingCharRegExp) : void 0) {
      return true;
    }
    if (this.breakAll) {
      return false;
    }
    if (word1.isAlphaNumeric && word2.isAlphaNumeric) {
      return true;
    }
    return !!word2.str.match(this.notStartingCharRegExp);
  };


  /**
  行末に来るべきでない文字の羅列
  
  @property {String} notEndingChars
  @private
   */

  JpWrap.prototype.notEndingChars = [CharacterClasses['Opening brackets']].join('');


  /**
  行頭に来るべきでない文字の羅列
  
  @property {String} notStartingChars
  @private
   */

  JpWrap.prototype.notStartingChars = [CharacterClasses['Closing brackets'], CharacterClasses['Hyphens'], CharacterClasses['Dividing punctuation marks'], CharacterClasses['Middle dots'], CharacterClasses['Full stops'], CharacterClasses['Commas'], CharacterClasses['Iteration marks'], CharacterClasses['Prolonged sound mark'], CharacterClasses['Small kana']].join('');


  /**
  行頭に来るべきでない文字の羅列(日本語半角文字)
  
  @property {String} notStartingCharsHalf
  @private
   */

  JpWrap.prototype.notStartingCharsHalf = [CharacterClasses['Closing brackets HANKAKU'], CharacterClasses['Middle dots HANKAKU'], CharacterClasses['Full stops HANKAKU'], CharacterClasses['Commas HANKAKU'], CharacterClasses['Prolonged sound mark HANKAKU'], CharacterClasses['Small kana HANKAKU']].join('');


  /**
  与えられた複数の文字列にマッチする条件の正規表現を作成
  
  @method getRegexFromStrs
  @private
  @static
  @return {RegExp}
   */

  JpWrap.getRegexFromStrs = function() {
    var strList;
    strList = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return new RegExp("[" + (strList.join('')) + "]");
  };

  return JpWrap;

})();

module.exports = JpWrap;
