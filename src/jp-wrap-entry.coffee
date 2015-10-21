
JpWrap = require './lib/jp-wrap'

###*
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
###
entry = (start, stop, options = {}) ->

    options.trim ?= false

    if typeof stop is 'object'
        options = stop
        stop = null

    if not stop
        jpWrap = new JpWrap(start, options)
        return (text) -> jpWrap.wrap(text).join('\n')


    jpWrap = new JpWrap(stop - start, options)
    spaces = (' ' for i in [0..stop]).join('')
    spacesStart = spaces.slice(0, start)

    return (text) ->

        lines = for line in jpWrap.getLines(text)
            spacesStart + line.str + spaces.slice(0, stop - line.width)
        lines.join('\n')


module.exports = entry
module.exports.JpWrap = JpWrap
