
Word = require '../../src/lib/word'

describe 'Word', ->

    describe '@widthByStr', ->

        it '空文字列に対して0を返す', ->

            expect(Word.widthByStr '').to.equal 0


        it '半角カタカナには1を返す', ->

            expect(Word.widthByStr 'ｱ').to.equal 1


        it 'ASCIIは1の幅として数える', ->

            expect(Word.widthByStr '|shin out|').to.equal 10


        it '全角文字は2の幅として数える', ->

            expect(Word.widthByStr 'メールアドレス').to.equal 14


        it 'sameWidthオプションがtrueの時、全角文字と半角文字の幅を両方とも2として計算する', ->

            options =
                sameWidth: true

            expect(Word.widthByStr('ｱ|shin out|メールアドレス', options)).to.equal 36

        it 'regexsオプションに{pattern: /[A-Za-z0-9_]/, width: 5}の時、英数文字の幅を5として計算する', ->

            options =
                regexs:
                    [
                        {pattern: /[A-Za-z0-9_]/, width: 5}
                    ]

            expect(Word.widthByStr('ｱ|shin out|メールアドレス', options)).to.equal 57


    describe 'constructor', ->

        it '引数なしならstrに空文字列をセット', ->

            expect(new Word().str).to.equal ''


        it 'widthを設定', ->

            expect(new Word().width).to.equal 0

            expect(new Word('CureApp').width).to.equal 7


        it '第2引数に{sameWidth: true}を渡すと、全角文字と半角文字の幅を両方とも2として計算する', ->

            expect(new Word('CureAppです', {sameWidth: true}).width).to.equal 18


    describe 'isAlphaNumeric', ->

        it '末尾がalphaNumericのときtrueとなる', ->

            expect(new Word('いえ、違いますa').isAlphaNumeric).to.be.true


        it '末尾がalphaNumericでないときfalseとなる', ->

            expect(new Word('CureApp禁煙').isAlphaNumeric).to.be.false


        it 'appendしても同じく、末尾のalphaNumericを反映する', ->

            word = new Word('CureApp禁煙')

            word.appendText('2')

            expect(word.str).to.equal 'CureApp禁煙2'
            expect(word.isAlphaNumeric).to.be.true

            word.appendText('、出た!')

            expect(word.str).to.equal 'CureApp禁煙2、出た!'
            expect(word.isAlphaNumeric).to.be.false


    describe 'last', ->

        it 'strが空文字列ならundefinedを返す', ->

            expect(new Word().last()).to.be.undefined

        it '文字があれば最後の文字を返す', ->

            expect(new Word('やまびこ').last()).to.equal 'こ'



    describe 'ltrim', ->

        it 'strが空白を含まないなら何もしない', ->

            expect(new Word('あいう').ltrim().str).to.equal 'あいう'


        it 'strが空白を含むなら空白のみ削除する', ->

            word = new Word('   it was rainy ').ltrim()

            expect(word.str).to.equal 'it was rainy '
            expect(word.width).to.equal 13


        it '引数がないなら、strが全角を含んでも半角空白のみ削除する', ->

            word = new Word(' 　  it was rainy ').ltrim()

            expect(word.str).to.equal '　  it was rainy '
            expect(word.width).to.equal 17


        it '引数がtrueなら、全角空白も削除する', ->

            word = new Word(' 　  it was rainy ').ltrim(true)

            expect(word.str).to.equal 'it was rainy '
            expect(word.width).to.equal 13



    describe 'append', ->

        it '文字を末尾に連結する', ->

            word1 = new Word('ABCから')

            word2 = new Word('Zまで')

            word1.append word2

            expect(word1.str).to.equal 'ABCからZまで'
            expect(word1.width).to.equal 12
            expect(word1.isAlphaNumeric).to.be.false


        it '改行がある場合はエラー', ->

            word1 = new Word('ABCから')

            word1.appendLineBreak('\n')

            word2 = new Word('Zまで')

            expect(-> word1.append word2).to.throw 'hasLineBreak'



    describe 'appendText', ->

        it '文字を末尾に連結する', ->

            word = new Word('ABCから')

            str = 'Zまで'

            word.appendText str

            expect(word.str).to.equal 'ABCからZまで'
            expect(word.width).to.equal 12
            expect(word.isAlphaNumeric).to.be.false


        it '改行がある場合はエラー', ->

            word = new Word('ABCから')

            word.appendLineBreak('\n')

            expect(-> word.appendText 'Yまで').to.throw 'hasLineBreak'



    describe 'appendLineBreak', ->

        it '入力された文字は連結せず、lbStrプロパティに格納', ->

            word = new Word('です。')

            word.appendLineBreak('\n')

            expect(word.str).to.equal 'です。'
            expect(word.width).to.equal 6
            expect(word.lbStr).to.equal '\n'


        it 'isAlphaNumericはfalseになる', ->

            word = new Word('abc123')

            expect(word.isAlphaNumeric).to.be.true

            word.appendLineBreak('\n')

            expect(word.isAlphaNumeric).to.be.false


    describe 'hasStr', ->

        it '空文字列の場合はfalse', ->

            expect(new Word().hasStr()).to.be.false
            expect(new Word('').hasStr()).to.be.false


        it '改行が加わっても空文字列の場合はfalse', ->

            expect(new Word().appendLineBreak('\n').hasStr()).to.be.false


        it '空文字列でなければtrue', ->

            expect(new Word('はい').hasStr()).to.be.true
            expect(new Word(' ').hasStr()).to.be.true



    describe 'hasLineBreak', ->

        it '改行を持つかどうかを返す', ->

            word = new Word()

            expect(word.hasLineBreak()).to.be.false

            word.appendLineBreak('\n')

            expect(word.hasLineBreak()).to.be.true

