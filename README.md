# jp-wrap
日本語の禁則処理に対応したword-wrap

## example

### made out of meat in Japanese

```js
var wrap = require('jp-wrap')(20);
console.log(wrap('「僕らはみんな、肉だ」とかって、substackが言ってたよ。'));
```

output:

    「僕らはみんな、肉
    だ」とかって、
    substackが言ってた
    よ。


### centered

```js
var wrap = require('jp-wrap')(20, 60);

console.log(wrap(
    'CureAppは、アプリを薬のように医師が処方する時代を創っていく会社です。' +
    '20世紀の医学は感染症をcontrollableなものとしました。' +
    '平均寿命が延伸するにつれて見えてきた、21世紀の医療の大きな課題は生活習慣病です。' +
    'しかし生活習慣は、当たり前のことですが、 病院の中にはありません。' +
    '医療が介入しにくい場所にあった生活習慣。そこに24時間介入できるのが、' +
    'アプリでしょう。最新のevidenceやガイドラインに沿った指導を毎日行います。' +
    '「アプリの治療が当たり前になる」そんな未来を創っていきたいのです。'
));
```

output:

                        CureAppは、アプリを薬のように医師が処方                     
                        する時代を創っていく会社です。20世紀の医                    
                        学は感染症をcontrollableなものとしまし                      
                        た。平均寿命が延伸するにつれて見えてき                      
                        た、21世紀の医療の大きな課題は生活習慣病                    
                        です。しかし生活習慣は、当たり前のことで                    
                        すが、病院の中にはありません。医療が介入                    
                        しにくい場所にあった生活習慣。そこに24時                    
                        間介入できるのが、アプリでしょう。最新の                    
                        evidenceやガイドラインに沿った指導を毎日                    
                        行います。「アプリの治療が当たり前にな                      
                        る」そんな未来を創っていきたいのです。                      


## install

```sh
npm install jp-wrap
```

## methods
[substack/node-wordwrap](https://github.com/substack/node-wordwrap)と似たAPIにしました。

```js
var jpWrap = require('jp-wrap');
```

### jpWrap(stop, options)
文字列を受け取って、新しい文字列を返す関数 を返す.
`stop`は文字の幅。

### jpWrap(start, stop, options)

2つの数字が与えられたときは
文字列を与えると`stop - start`の幅でwrapし、左右にstartだけのpaddingをつける関数 を返す.

### options
| name           | type    | 意味                                        | デフォルト |
|:---------------|:--------|:--------------------------------------------|:-----------|
| trim           | boolean | 入力文字列の改行を利用しないときtrue        | false      |
| half           | boolean | 半角文字の行頭禁則処理を行うかどうか        | false      |
| breakAll       | boolean | trueだとcssのword-break:break-allと同じ挙動 | false      |
| fullWidthSpace | boolean | 全角スペースが行頭にあった場合削除するか    | true       |


### もっと内部をさわりたい方

```js
var JpWrap = require('jp-wrap').JpWrap;
```
クラスが取れます。
API docsは準備中、しかしyuidocで生成されるようコメントは詳しく書いています。


## LICENSE
MIT

## thanks to
下記を参考にし、改変しました。
- [raccy/japanese-wrap](https://github.com/raccy/japanese-wrap)
- [substack/node-wordwrap](https://github.com/substack/node-wordwrap)

<japanese-wrap>
Copyright(c) 2014-2015 IGARASHI Makoto
https://raw.githubusercontent.com/raccy/japanese-wrap/master/LICENSE.md

<node-wordwrap>
Copyright(c) 2013-2015 James Halliday
https://raw.githubusercontent.com/substack/node-wordwrap/master/LICENSE
