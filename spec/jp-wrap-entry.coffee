
entry = require '../src/jp-wrap-entry'

JpWrap = require '../src/lib/jp-wrap'

describe 'entry', ->

    describe 'JpWrap', ->

        it 'is JpWrapクラス', ->

            assert entry.JpWrap is JpWrap


    it '第2引数にobjectを与えた場合それがoptionsとして解釈される', ->

        wrap = entry(20, trim: true)

        assert wrap('あいう\nえお') is 'あいうえお'


    it '第2引数に数値を与えた場合それがstopとして解釈される', ->

        wrap = entry(2, 12)

        assert wrap('あいう\nえお') is '  あいう      \n  えお        '


    it '第3引数にはoptionsを与えられる', ->

        wrap = entry(2, 12, trim: true)

        assert wrap('あいう\nえお') is '  あいうえお  '


    it 'CoffeeScriptへの熱い思いを整形', ->

        str = """
テストを見て/実行してくれてありがとう。
ご覧のとおりこのライブラリはCoffeeScriptで書かれています。
そう、あの衰退してゆく斜陽言語でね。

でも「CoffeeScriptなんて元々乗るべき技術じゃなかった」とは言ってあげないで。
「CoffeeScriptが費用対効果悪かった」とも言ってあげないで。

私はCoffeeScriptほど学習コストがかからず生産性高いコードを書ける言語を知らないです。
たとえばこのレポジトリをちょっと読んでみてください。
日本語のwordwrapという複雑なロジックにもかかわらず、
簡潔で可読性/保守性の高いコードになっていると思うけど、
それもCoffeeScriptのおかげです。

「CoffeeScriptが死にゆくのは、CoffeeScriptの内的要因によってじゃない」。
オピニオンリーダーに追従し、何かCoffeeScriptにツバを吐き捨てて
今風になりたい方々にはそれを伝えたいです。
テストを見てくれているあなたはそうではないのが残念ですが。

アロー演算子による関数定義はもちろん、class定義、可変長引数の定義/代入、
デフォルト引数、returnの省略、thisの@、配列やオブジェクトのスマートな変数展開。
内包表記や 値を持つfor, if, while。nullとundefinedをまとめる存在演算子 "?"。
括弧やカンマの省略。後置if, unless。 not, is, and, or, isnt, on, off, yes, no。
なんて美しくコードを書けるんだと、ため息がもれるほどです。
これらひとつでも使わないで書くのが辛いです。

某氏が指摘するように、ES6の台頭を背景に、プロジェクトの活気がなくなってきたこと。
その外的要因によってこそ、CoffeeScriptは死にゆくのです。

CoffeeScriptはES6の基盤となったことは間違いない事実です。
それは私達の望んだ100%のものではないですが、いくつかの機能は同じように使えます。
しかしそれでも乗り換えに際して、ES6でよかったといえる部分より、
CoffeeScriptがよかったと思う部分のほうが多いとのではないでしょうか。
letやgeneratorを使いこなし、少しだけ違うclass定義を書き、
律儀に括弧をつけ、あいも変わらずObject.keys().forEach なのかもしれません。
未練たらしいですね、とにかく私をプログラミングに熱中させてくれたCoffeeScript、ありがとう。

2015.10.03 SHIN Suzuki
"""
        console.log ''
        console.log entry(20, 120, trim: true)(str)


