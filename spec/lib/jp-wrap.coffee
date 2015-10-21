
JpWrap = require '../../src/lib/jp-wrap'
Word = require '../../src/lib/word'

describe 'JpWrap', ->


    describe 'constructor', ->

        it 'widthプロパティを第1引数から設定 デフォルトは100', ->

            expect(new JpWrap().width).to.equal 100
            expect(new JpWrap(10).width).to.equal 10


        it 'trimプロパティをオプションから設定 デフォルトはtrue', ->
            expect(new JpWrap().trim).to.be.true
            expect(new JpWrap(100, trim: true).trim).to.be.true
            expect(new JpWrap(100, trim: false).trim).to.be.false
            expect(new JpWrap(100, trim: null).trim).to.be.true
            expect(new JpWrap(100, trim: 0).trim).to.be.false


        it 'breakAllプロパティをオプションから設定 デフォルトはfalse', ->

            expect(new JpWrap().breakAll).to.be.false
            expect(new JpWrap(100, breakAll: false).breakAll).to.be.false
            expect(new JpWrap(100, breakAll: true).breakAll).to.be.true
            expect(new JpWrap(100, breakAll: null).breakAll).to.be.false
            expect(new JpWrap(100, breakAll: 0).breakAll).to.be.false
            expect(new JpWrap(100, breakAll: 1).breakAll).to.be.true



        it 'halfオプションをオプションから設定 デフォルトはfalse', ->

            expect(new JpWrap().half).to.be.false
            expect(new JpWrap(100, half: false).half).to.be.false
            expect(new JpWrap(100, half: true).half).to.be.true
            expect(new JpWrap(100, half: null).half).to.be.false
            expect(new JpWrap(100, half: 0).half).to.be.false
            expect(new JpWrap(100, half: 1).half).to.be.true


        it 'sameWidthオプションをオプションから設定 デフォルトはfalse', ->

            expect(new JpWrap().sameWidth).to.be.false
            expect(new JpWrap(100, sameWidth: false).sameWidth).to.be.false
            expect(new JpWrap(100, sameWidth: true).sameWidth).to.be.true
            expect(new JpWrap(100, sameWidth: null).sameWidth).to.be.false
            expect(new JpWrap(100, sameWidth: 0).sameWidth).to.be.false
            expect(new JpWrap(100, sameWidth: 1).sameWidth).to.be.true


    describe 'isJoinable', ->

        it '2つのwordの長さがmaxWidthを超えたらfalse', ->

            word1 = new Word('俺とお前と')
            word2 = new Word('大五郎')

            expect(new JpWrap(12).isJoinable(word1, word2)).to.be.false


        it 'word1の最後が、末尾禁則の文字にマッチしていたらtrue', ->

            word1 = new Word('しん「')
            word2 = new Word('こっちこいよ」')

            expect(new JpWrap().isJoinable(word1, word2)).to.be.true

        it 'word1の最後が、末尾禁則の文字にマッチしていたらbreakAll:trueでもtrue', ->

            word1 = new Word('しん「')
            word2 = new Word('こっちこいよ」')

            expect(new JpWrap(100, breakAll: true).isJoinable(word1, word2)).to.be.true


        it 'word1の最後が、行末禁則の文字にマッチしなくてbreakAll:trueならfalse', ->

            word1 = new Word('iPad ')
            word2 = new Word('Air')

            expect(new JpWrap(100, breakAll: true).isJoinable(word1, word2)).to.be.false


        it 'word1もword2も半角英数で終わっていたらtrue', ->

            word1 = new Word('room')
            word2 = new Word('335')

            expect(new JpWrap().isJoinable(word1, word2)).to.be.true


        it 'word2が行頭禁則の文字にマッチしてたらtrue', ->

            word1 = new Word('モーニングなんとか')
            word2 = new Word('。')

            expect(new JpWrap().isJoinable(word1, word2)).to.be.true


        it 'word2が行頭禁則の文字にマッチしてなければfalse', ->

            word1 = new Word('ドラゴンクエスト')
            word2 = new Word('Ⅴ')

            expect(new JpWrap().isJoinable(word1, word2)).to.be.false



    describe 'splitTextIntoWords', ->

        it '日本語は1文字ずつに分けられる', ->

            words = new JpWrap().splitTextIntoWords('つのだ☆なんとか')

            expect(words).to.have.length 8


        it 'alphanumericは1単語にまとめられる', ->

            words = new JpWrap().splitTextIntoWords('それevidenceはあるのか')

            expect(words).to.have.length 8

            expect(words[2]).to.have.property 'str', 'evidence'



        it '行頭禁則文字は前の文字にまとめられる', ->

            words = new JpWrap().splitTextIntoWords('藤岡さん、電話です。')

            expect(words).to.have.length 8

            expect(words[3]).to.have.property 'str', 'ん、'
            expect(words[7]).to.have.property 'str', 'す。'


        it '行頭禁則文字でも前の文字がなければ単独で存在', ->

            words = new JpWrap().splitTextIntoWords('。だとさ')

            expect(words).to.have.length 4

            expect(words[0]).to.have.property 'str', '。'


        it '行末禁則文字は次の文字と繋げられる', ->

            words = new JpWrap().splitTextIntoWords('ハチ「渋谷へようこそ」')

            expect(words).to.have.length 9

            expect(words[2]).to.have.property 'str', '「渋'
            expect(words[8]).to.have.property 'str', 'そ」'


        it '長い単語は、widthまでに分割される', ->

            words = new JpWrap(10).splitTextIntoWords('今日本に必要なinternationalization。')

            expect(words).to.have.length 10

            expect(words[7]).to.have.property 'str', 'internatio'
            expect(words[8]).to.have.property 'str', 'nalization'
            expect(words[9]).to.have.property 'str', '。' # 長いので行末禁則だがつながらなかった TODO これでいいのか？


        it '改行文字はtrimされる', ->

            words = new JpWrap().splitTextIntoWords('好きな人が、\nできました。')

            expect(words).to.have.length 10

            expect(words[4]).to.have.property 'str', 'が、'
            expect(words[4].hasLineBreak()).to.be.false


        it 'trimがfalseの場合改行文字でwordが分かれる', ->

            words = new JpWrap(100, trim: false).splitTextIntoWords('loop\nback')

            expect(words).to.have.length 2

            expect(words[0]).to.have.property 'str', 'loop'
            expect(words[0].hasLineBreak()).to.be.true


    describe 'wrap', ->


        it '単語が入りきらなければ次の行に流し込まれる', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                'インスタンスの生成で'
                'すが、factory.'
                'createFromObject(obj'
                ') してください。'
            ]


        it '単語がwidthより長ければ分断される', ->

            text = 'WYSIWYGは、what_you_see_is_what_you_getのこと。'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                'WYSIWYGは、'
                'what_you_see_is_what'
                '_you_getのこと。'
            ]


        it '行頭は半角スペースで始まらない', ->

            text = 'in the town, where I was born'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                'in the town, where I'
                'was born'
            ]


        it '行頭は全角スペースで始まらない', ->

            text = 'in the town, where I　was born'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                'in the town, where I'
                'was born'
            ]



        it 'fullWidthSpace: false の時は行頭は全角スペースで始まる', ->

            text = 'in the town, where I　was born'

            lines = new JpWrap(20, fullWidthSpace: false).wrap(text)

            expect(lines).to.eql [
                'in the town, where I'
                '　was born'
            ]



        it '末尾に「 が来ないように、来そうなときは次の行に移る', ->

            text = 'ゼンメルワイスは、「患者を殺していたのは医師の手である」と言った。'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                'ゼンメルワイスは、'
                '「患者を殺していたの'
                'は医師の手である」と'
                '言った。'
            ]


        it '行頭に 。 が来ないように、来そうなときは前の文字が次の行に移る', ->

            text = '残り物には夏服がある。もう秋だ。'

            lines = new JpWrap(20).wrap(text)

            expect(lines).to.eql [
                '残り物には夏服があ'
                'る。もう秋だ。'
            ]


        it 'trim: false のときは、改行がそのまま出力される。', ->

            text = '1. 東京\n2. 有楽町\n3. 新橋'

            lines = new JpWrap(20, trim: false).wrap(text)

            expect(lines).to.eql [
                '1. 東京'
                '2. 有楽町'
                '3. 新橋'
            ]


        it 'trim: false で、ちょうど改行に重なるときは、空行を作らない。', ->

            text = '1. 東京\n2. 有楽町\n3. 新橋'

            lines = new JpWrap(7, trim: false).wrap(text)

            expect(lines).to.eql [
                '1. 東京'
                '2. 有楽'
                '町'
                '3. 新橋'
            ]


        it 'breakAll: trueなら、単語の長さは考慮されずに行を埋めるだけ埋める', ->

            text = 'WYSIWYGは、what_you_see_is_what_you_getのこと。'

            lines = new JpWrap(20, breakAll: true).wrap(text)

            expect(lines).to.eql [
                'WYSIWYGは、what_you_'
                'see_is_what_you_get'
                'のこと。'
            ]


        it 'sameWidth: trueなら、全角文字と半角文字の幅を両方とも2として計算する', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20, sameWidth: true).wrap(text)

            expect(lines).to.eql [
                'インスタンスの生成で'
                'すが、factory'
                '.'
                'createFrom'
                'Object(obj'
                ') してください。'
            ]


