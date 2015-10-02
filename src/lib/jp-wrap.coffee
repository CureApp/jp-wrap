
CharacterClasses = require './character-classes'

Word = require './word'

###*
日本語の禁則処理を行って改行する

@class JpWrap
@module jp-wrap
###
class JpWrap

    ###*
    @constructor
    @param {Object} [options]
    @param {Boolean} [options.half] 半角文字の行頭禁則処理を行うか
    @param {Boolean} [options.trim=true] 入力文字列の改行を取り除くかどうか
    @param {Boolean} [options.breakAll] trueだとcssのword-break:break-allと同じ挙動をする
    ###
    constructor: (options = {}) ->

        @trim = !! (options.trim ? true)
        @breakAll = !! options.breakAll

        regexStr = @notStartingChars

        if options.half
            regexStr += @notStartingCharsHalf

        @notStartingCharRegExp = @constructor.getRegexFromStrs regexStr

        @notEndingCharRegExp = @constructor.getRegexFromStrs @notEndingChars

    ###*
    textが、幅: width (半角1, 全角2とする) で、どのようにsplitされるか
    戦略：文字列を単語ごとに分解してから、行を埋めていく

    @method wrap
    @public
    @param {String} text
    @param {Number} width
    @return {Array(String)} lines 分割された行の配列
    ###
    wrap: (text, width) ->

        lines = []

        words = @splitTextIntoWords(text, width)

        currentLine = null

        for word in words

            if not currentLine?
                currentLine = word

            else if currentLine.hasLineBreak()
                lines.push currentLine.str
                currentLine = word

            else if currentLine.width + word.width <= width
                currentLine.append word

            else
                lines.push currentLine.str
                currentLine = word

        lines.push currentLine.str if currentLine.hasStr()

        return lines


    ###*
    与えられた文字列を単語に分割
    行頭に来ることができないものを前の文字の続きにして分割

    @method splitTextIntoWords
    @private
    @param {String} text
    @param {Number} maxWidth 単語の最大サイズ
    @return {Array(Word)}
    ###
    splitTextIntoWords: (text, maxWidth) ->

        words = []

        currentWord = new Word()

        for c in text

            if c is '\n'

                if not @trim
                    words.push currentWord.appendLineBreak(c)
                    currentWord = new Word()

                continue

            word = new Word(c)

            if @isJoinable(currentWord, word, maxWidth)

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
    isJoinable: (word1, word2, maxWidth) ->

        return false if word1.width + word2.width > maxWidth

        return true if word1.last()?.match @notEndingCharRegExp

        return false if @breakAll

        return true if word1.isAlphaNumeric and word2.isAlphaNumeric

        return !! word2.str.match(@notStartingCharRegExp)


    ###*
    行末に来るべきでない文字の羅列

    @property {String} notEndingChars
    @private
    ###
    notEndingChars: [
        CharacterClasses['Opening brackets']
    ].join('')


    ###*
    行頭に来るべきでない文字の羅列

    @property {String} notStartingChars
    @private
    ###
    notStartingChars: [
        CharacterClasses['Closing brackets']
        CharacterClasses['Hyphens']
        CharacterClasses['Dividing punctuation marks']
        CharacterClasses['Middle dots']
        CharacterClasses['Full stops']
        CharacterClasses['Commas']
        CharacterClasses['Iteration marks']
        CharacterClasses['Prolonged sound mark']
        CharacterClasses['Small kana']
    ].join('')


    ###*
    行頭に来るべきでない文字の羅列(日本語半角文字)

    @property {String} notStartingCharsHalf
    @private
    ###
    notStartingCharsHalf: [
        CharacterClasses['Closing brackets HANKAKU'],
        CharacterClasses['Middle dots HANKAKU'],
        CharacterClasses['Full stops HANKAKU'],
        CharacterClasses['Commas HANKAKU'],
        CharacterClasses['Prolonged sound mark HANKAKU'],
        CharacterClasses['Small kana HANKAKU'],
    ].join('')


    ###*
    与えられた複数の文字列にマッチする条件の正規表現を作成

    @method getRegexFromStrs
    @private
    @static
    @return {RegExp}
    ###
    @getRegexFromStrs: (strList...) ->

        new RegExp "[#{strList.join('')}]"


module.exports = JpWrap
