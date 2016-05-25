
Word = require '../../src/lib/word'

describe 'Word', ->

    describe '@widthByStr', ->

        it '空文字列に対して0を返す', ->

            assert Word.widthByStr('') is 0


        it '半角カタカナには1を返す', ->

            assert Word.widthByStr('ｱ') is 1


        it 'ASCIIは1の幅として数える', ->

            assert Word.widthByStr('|shin out|') is 10


        it '全角文字は2の幅として数える', ->

            assert Word.widthByStr('メールアドレス') is 14


        it 'sameWidthオプションがtrueの時、全角文字と半角文字の幅を両方とも2として計算する', ->

            options =
                sameWidth: true

            assert Word.widthByStr('ｱ|shin out|メールアドレス', options) is 36

        it 'regexsオプションに{pattern: /[A-Za-z0-9_]/, width: 5}の時、英数文字の幅を5として計算する', ->

            options =
                regexs:
                    [
                        {pattern: /[A-Za-z0-9_]/, width: 5}
                    ]

            assert Word.widthByStr('ｱ|shin out|メールアドレス', options) is 57


    describe 'constructor', ->

        it '引数なしならstrに空文字列をセット', ->

            assert new Word().str is ''


        it 'widthを設定', ->

            assert new Word().width is 0

            assert new Word('CureApp').width is 7


        it '第2引数に{sameWidth: true}を渡すと、全角文字と半角文字の幅を両方とも2として計算する', ->

            assert new Word('CureAppです', {sameWidth: true}).width is 18


    describe 'isAlphaNumeric', ->

        it '末尾がalphaNumericのときtrueとなる', ->

            assert new Word('いえ、違いますa').isAlphaNumeric is true


        it '末尾がalphaNumericでないときfalseとなる', ->

            assert new Word('CureApp禁煙').isAlphaNumeric is false


        it 'appendしても同じく、末尾のalphaNumericを反映する', ->

            word = new Word('CureApp禁煙')

            word.appendText('2')

            assert word.str is 'CureApp禁煙2'
            assert word.isAlphaNumeric is true

            word.appendText('、出た!')

            assert word.str is 'CureApp禁煙2、出た!'
            assert word.isAlphaNumeric is false


    describe 'last', ->

        it 'strが空文字列ならundefinedを返す', ->

            assert new Word().last() is undefined

        it '文字があれば最後の文字を返す', ->

            assert new Word('やまびこ').last() is 'こ'



    describe 'ltrim', ->

        it 'strが空白を含まないなら何もしない', ->

            assert new Word('あいう').ltrim().str is 'あいう'


        it 'strが空白を含むなら空白のみ削除する', ->

            word = new Word('   it was rainy ').ltrim()

            assert word.str is 'it was rainy '
            assert word.width is 13


        it '引数がないなら、strが全角を含んでも半角空白のみ削除する', ->

            word = new Word(' 　  it was rainy ').ltrim()

            assert word.str is '　  it was rainy '
            assert word.width is 17


        it '引数がtrueなら、全角空白も削除する', ->

            word = new Word(' 　  it was rainy ').ltrim(true)

            assert word.str is 'it was rainy '
            assert word.width is 13



    describe 'append', ->

        it '文字を末尾に連結する', ->

            word1 = new Word('ABCから')

            word2 = new Word('Zまで')

            word1.append word2

            assert word1.str is 'ABCからZまで'
            assert word1.width is 12
            assert word1.isAlphaNumeric is false


        it '改行がある場合はエラー', ->

            word1 = new Word('ABCから')

            word1.appendLineBreak('\n')

            word2 = new Word('Zまで')

            assert.throws(-> word1.append word2) is 'hasLineBreak'



    describe 'appendText', ->

        it '文字を末尾に連結する', ->

            word = new Word('ABCから')

            str = 'Zまで'

            word.appendText str

            assert word.str is 'ABCからZまで'
            assert word.width is 12
            assert word.isAlphaNumeric is false


        it '改行がある場合はエラー', ->

            word = new Word('ABCから')

            word.appendLineBreak('\n')

            assert.throws(-> word.appendText 'Yまで') is 'hasLineBreak'



    describe 'appendLineBreak', ->

        it '入力された文字は連結せず、lbStrプロパティに格納', ->

            word = new Word('です。')

            word.appendLineBreak('\n')

            assert word.str is 'です。'
            assert word.width is 6
            assert word.lbStr is '\n'


        it 'isAlphaNumericはfalseになる', ->

            word = new Word('abc123')

            assert word.isAlphaNumeric is true

            word.appendLineBreak('\n')

            assert word.isAlphaNumeric is false


    describe 'hasStr', ->

        it '空文字列の場合はfalse', ->

            assert new Word().hasStr() is false
            assert new Word('').hasStr() is false


        it '改行が加わっても空文字列の場合はfalse', ->

            assert new Word().appendLineBreak('\n').hasStr() is false


        it '空文字列でなければtrue', ->

            assert new Word('はい').hasStr() is true
            assert new Word(' ').hasStr() is true



    describe 'hasLineBreak', ->

        it '改行を持つかどうかを返す', ->

            word = new Word()

            assert word.hasLineBreak() is false

            word.appendLineBreak('\n')

            assert word.hasLineBreak() is true

