
JpWrap = require '../../src/lib/jp-wrap'
Word = require '../../src/lib/word'

describe 'JpWrap', ->


    describe 'constructor', ->

        it 'widthプロパティを第1引数から設定 デフォルトは100', ->

            assert new JpWrap().width is 100
            assert new JpWrap(10).width is 10


        it 'trimプロパティをオプションから設定 デフォルトはtrue', ->
            assert new JpWrap().trim is true
            assert new JpWrap(100, trim: true).trim is true
            assert new JpWrap(100, trim: false).trim is false
            assert new JpWrap(100, trim: null).trim is true
            assert new JpWrap(100, trim: 0).trim is false


        it 'breakAllプロパティをオプションから設定 デフォルトはfalse', ->

            assert new JpWrap().breakAll is false
            assert new JpWrap(100, breakAll: false).breakAll is false
            assert new JpWrap(100, breakAll: true).breakAll is true
            assert new JpWrap(100, breakAll: null).breakAll is false
            assert new JpWrap(100, breakAll: 0).breakAll is false
            assert new JpWrap(100, breakAll: 1).breakAll is true


        it 'halfオプションをオプションから設定 デフォルトはfalse', ->

            assert new JpWrap().half is false
            assert new JpWrap(100, half: false).half is false
            assert new JpWrap(100, half: true).half is true
            assert new JpWrap(100, half: null).half is false
            assert new JpWrap(100, half: 0).half is false
            assert new JpWrap(100, half: 1).half is true


        it 'sameWidthオプションをオプションから設定 デフォルトはfalse', ->

            assert new JpWrap().sameWidth is false
            assert new JpWrap(100, sameWidth: false).sameWidth is false
            assert new JpWrap(100, sameWidth: true).sameWidth is true
            assert new JpWrap(100, sameWidth: null).sameWidth is false
            assert new JpWrap(100, sameWidth: 0).sameWidth is false
            assert new JpWrap(100, sameWidth: 1).sameWidth is true


        it 'regexsオプションをオプションから設定 デフォルトは空の配列', ->

            assert new JpWrap().regexs.length is 0
            assert new JpWrap(100, regexs: [{pattern: /[a-z]/, width: 1}]).regexs.length is 1
            assert new JpWrap(100, regexs: [{pattern: /[a-z]/, width: 1}]).regexs[0].width is 1
            assert new JpWrap(100, regexs: null).regexs.length is 0


    describe 'isJoinable', ->

        it '2つのwordの長さがmaxWidthを超えたらfalse', ->

            word1 = new Word('俺とお前と')
            word2 = new Word('大五郎')

            assert new JpWrap(12).isJoinable(word1, word2) is false


        it 'word1の最後が、末尾禁則の文字にマッチしていたらtrue', ->

            word1 = new Word('しん「')
            word2 = new Word('こっちこいよ」')

            assert new JpWrap().isJoinable(word1, word2) is true

        it 'word1の最後が、末尾禁則の文字にマッチしていたらbreakAll:trueでもtrue', ->

            word1 = new Word('しん「')
            word2 = new Word('こっちこいよ」')

            assert new JpWrap(100, breakAll: true).isJoinable(word1, word2) is true


        it 'word1の最後が、行末禁則の文字にマッチしなくてbreakAll:trueならfalse', ->

            word1 = new Word('iPad ')
            word2 = new Word('Air')

            assert new JpWrap(100, breakAll: true).isJoinable(word1, word2) is false


        it 'word1もword2も半角英数で終わっていたらtrue', ->

            word1 = new Word('room')
            word2 = new Word('335')

            assert new JpWrap().isJoinable(word1, word2) is true


        it 'word2が行頭禁則の文字にマッチしてたらtrue', ->

            word1 = new Word('モーニングなんとか')
            word2 = new Word('。')

            assert new JpWrap().isJoinable(word1, word2) is true


        it 'word2が行頭禁則の文字にマッチしてなければfalse', ->

            word1 = new Word('ドラゴンクエスト')
            word2 = new Word('Ⅴ')

            assert new JpWrap().isJoinable(word1, word2) is false



    describe 'splitTextIntoWords', ->

        it '日本語は1文字ずつに分けられる', ->

            words = new JpWrap().splitTextIntoWords('つのだ☆なんとか')

            assert words.length is 8


        it 'alphanumericは1単語にまとめられる', ->

            words = new JpWrap().splitTextIntoWords('それevidenceはあるのか')

            assert words.length is 8

            assert words[2].str is 'evidence'



        it '行頭禁則文字は前の文字にまとめられる', ->

            words = new JpWrap().splitTextIntoWords('藤岡さん、電話です。')

            assert words.length is 8

            assert words[3].str is 'ん、'
            assert words[7].str is 'す。'


        it '行頭禁則文字でも前の文字がなければ単独で存在', ->

            words = new JpWrap().splitTextIntoWords('。だとさ')

            assert words.length is 4

            assert words[0].str is '。'


        it '行末禁則文字は次の文字と繋げられる', ->

            words = new JpWrap().splitTextIntoWords('ハチ「渋谷へようこそ」')

            assert words.length is 9

            assert words[2].str is '「渋'
            assert words[8].str is 'そ」'


        it '長い単語は、widthまでに分割される', ->

            words = new JpWrap(10).splitTextIntoWords('今日本に必要なinternationalization。')

            assert words.length is 10

            assert words[7].str is 'internatio'
            assert words[8].str is 'nalization'
            assert words[9].str is '。' # 長いので行末禁則だがつながらなかった TODO これでいいのか？


        it '改行文字はtrimされる', ->

            words = new JpWrap().splitTextIntoWords('好きな人が、\nできました。')

            assert words.length is 10

            assert words[4].str is 'が、'
            assert words[4].hasLineBreak() is false


        it 'trimがfalseの場合改行文字でwordが分かれる', ->

            words = new JpWrap(100, trim: false).splitTextIntoWords('loop\nback')

            assert words.length is 2

            assert words[0].str is 'loop'
            assert words[0].hasLineBreak() is true


    describe 'wrap', ->


        it '単語が入りきらなければ次の行に流し込まれる', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                'インスタンスの生成で'
                'すが、factory.'
                'createFromObject(obj'
                ') してください。'
            ]


        it '単語がwidthより長ければ分断される', ->

            text = 'WYSIWYGは、what_you_see_is_what_you_getのこと。'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                'WYSIWYGは、'
                'what_you_see_is_what'
                '_you_getのこと。'
            ]


        it '行頭は半角スペースで始まらない', ->

            text = 'in the town, where I was born'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                'in the town, where I'
                'was born'
            ]


        it '行頭は全角スペースで始まらない', ->

            text = 'in the town, where I　was born'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                'in the town, where I'
                'was born'
            ]



        it 'fullWidthSpace: false の時は行頭は全角スペースで始まる', ->

            text = 'in the town, where I　was born'

            lines = new JpWrap(20, fullWidthSpace: false).wrap(text)

            assert.deepEqual lines, [
                'in the town, where I'
                '　was born'
            ]



        it '末尾に「 が来ないように、来そうなときは次の行に移る', ->

            text = 'ゼンメルワイスは、「患者を殺していたのは医師の手である」と言った。'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                'ゼンメルワイスは、'
                '「患者を殺していたの'
                'は医師の手である」と'
                '言った。'
            ]


        it '行頭に 。 が来ないように、来そうなときは前の文字が次の行に移る', ->

            text = '残り物には夏服がある。もう秋だ。'

            lines = new JpWrap(20).wrap(text)

            assert.deepEqual lines, [
                '残り物には夏服があ'
                'る。もう秋だ。'
            ]


        it 'trim: false のときは、改行がそのまま出力される。', ->

            text = '1. 東京\n2. 有楽町\n3. 新橋'

            lines = new JpWrap(20, trim: false).wrap(text)

            assert.deepEqual lines, [
                '1. 東京'
                '2. 有楽町'
                '3. 新橋'
            ]


        it 'trim: false で、ちょうど改行に重なるときは、空行を作らない。', ->

            text = '1. 東京\n2. 有楽町\n3. 新橋'

            lines = new JpWrap(7, trim: false).wrap(text)

            assert.deepEqual lines, [
                '1. 東京'
                '2. 有楽'
                '町'
                '3. 新橋'
            ]


        it 'breakAll: trueなら、単語の長さは考慮されずに行を埋めるだけ埋める', ->

            text = 'WYSIWYGは、what_you_see_is_what_you_getのこと。'

            lines = new JpWrap(20, breakAll: true).wrap(text)

            assert.deepEqual lines, [
                'WYSIWYGは、what_you_'
                'see_is_what_you_get'
                'のこと。'
            ]


        it 'sameWidth: trueなら、全角文字と半角文字の幅を両方とも2として計算する', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20, {sameWidth: true}).wrap(text)

            assert.deepEqual lines, [
                'インスタンスの生成で'
                'すが、factory'
                '.'
                'createFrom'
                'Object(obj'
                ') してください。'
            ]


        it 'regexs: [{pattern: /[a-z]/, width: 5}]なら、小文字のアルファベットを幅5で計算する', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20, {regexs: [{pattern: /[a-z]/, width: 5}]}).wrap(text)

            assert.deepEqual lines, [
                'インスタンスの生成で'
                'すが、'
                'fact'
                'ory.'
                'crea'
                'teFr'
                'omOb'
                'ject'
                '(obj)'
                'してください。'
            ]


        it 'regexs: [{pattern: /[a-z]/, width: 5}, {pattern: /[A-Z]/, width: 10}]なら、小文字のアルファベットを幅5、大文字のアルファベットを幅10で計算する', ->

            text = 'インスタンスの生成ですが、factory.createFromObject(obj) してください。'

            lines = new JpWrap(20, {regexs: [{pattern: /[a-z]/, width: 5}, {pattern: /[A-Z]/, width: 10}]}).wrap(text)

            assert.deepEqual lines, [
                'インスタンスの生成で'
                'すが、'
                'fact'
                'ory.'
                'crea'
                'teF'
                'rom'
                'Obj'
                'ect('
                'obj) '
                'してください。'
            ]


