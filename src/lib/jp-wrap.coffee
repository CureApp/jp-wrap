
Word = require './word'

Regexps = require './regexps'

###*
日本語の禁則処理を行って改行する

@class JpWrap
@module jp-wrap
###
class JpWrap

    DEFAULT_WIDTH: 100

    @notStartingCharRegExp         : Regexps.notStartingChars
    @notStartingCharWithHalfRegExp : Regexps.notStartingCharsWithHalf
    @notEndingCharRegExp           : Regexps.notEndingChars

    ###*
    @constructor
    @param {Number} [width=100] 半角1, 全角2としたときの全体の幅
    @param {Object} [options]
    @param {Boolean} [options.half] 半角文字の行頭禁則処理を行うか
    @param {Boolean} [options.trim=true] 入力文字列の改行を取り除くかどうか
    @param {Boolean} [options.breakAll] trueだとcssのword-break:break-allと同じ挙動をする
    @param {Boolean} [options.fullWidthSpace=true] 全角スペースが行頭にあった場合削除するか
    @param {Boolean} [options.sameWidth] 全角文字と半角文字の幅を両方とも2として計算する
    @param {Object} [options.regexs] 幅の計算方法を正規表現で指定する
    ###
    constructor: (@width = @DEFAULT_WIDTH, options = {}) ->

        @trim = !! (options.trim ? true)
        @breakAll = !! options.breakAll
        @half = !! options.half
        @fullWidthSpace = !! (options.fullWidthSpace ? true)
        @regexs = (options.regexs ? [])
        @sameWidth = !! options.sameWidth


    ###*
    textを分割し、行(String)の配列を取得

    @method wrap
    @public
    @param {String} text
    @return {Array(String)} lines 分割された行の配列
    ###
    wrap: (text) ->

        (line.str for line in @getLines(text))


    ###*
    textを分割し、行(Wordオブジェクト)の配列を取得
    戦略：文字列を単語ごとに分解してから、行を埋めていく

    @method getLines
    @public
    @param {String} text
    @return {Array(String)} lines 分割された行の配列
    ###
    getLines: (text) ->

        lines = []

        words = @splitTextIntoWords(text)

        currentLine = null

        for word in words

            if not currentLine?
                currentLine = word.ltrim(@fullWidthSpace)

            else if currentLine.hasLineBreak()
                lines.push currentLine
                currentLine = word.ltrim(@fullWidthSpace)

            else if currentLine.width + word.width <= @width
                currentLine.append word

            else
                lines.push currentLine
                currentLine = word.ltrim(@fullWidthSpace)

        lines.push currentLine if currentLine.hasStr()

        return lines


    ###*
    与えられた文字列を単語に分割
    行頭に来ることができないものを前の文字の続きにして分割

    @method splitTextIntoWords
    @private
    @param {String} text
    @return {Array(Word)}
    ###
    splitTextIntoWords: (text) ->

        words = []

        currentWord = new Word('', {sameWidth: @sameWidth, regexs: @regexs})

        for c in text

            if c is '\n'

                if not @trim
                    words.push currentWord.appendLineBreak(c)
                    currentWord = new Word()

                continue

            word = new Word(c, {sameWidth: @sameWidth, regexs: @regexs})

            if @isJoinable(currentWord, word)

                currentWord.append word

            else
                words.push currentWord if currentWord.hasStr()
                currentWord = word

        words.push currentWord if currentWord.hasStr()

        return words


    ###*
    word1にword2をjoinしていいのかどうか
    @method isJoinable
    @private
    @param {Word} word1
    @param {Word} word2
    ###
    isJoinable: (word1, word2) ->

        return false if word1.width + word2.width > @width

        return true if word1.last()?.match @constructor.notEndingCharRegExp

        return false if @breakAll

        return true if word1.isAlphaNumeric and word2.isAlphaNumeric

        regex = if @half then @constructor.notStartingCharWithHalfRegExp else @constructor.notStartingCharRegExp

        return !! word2.str.match(regex)


module.exports = JpWrap
