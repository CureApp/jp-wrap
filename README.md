# jp-wrap
日本語の禁則処理をするライブラリ
no dependencies で、browserify等すれば環境問わず使える

## install

```sh
npm install jp-wrap
```

## usage

```js
var JpWrap = require('jp-wrap')

jpWrap = new JpWrap();

var text = '鈴木：「もう、wrapとかどうでもいいや。。。」\n 佐竹：「ちょっと！？それは困るよ」'
var lines = jpWrap.getLines(text, 10); // 10 は、 半角10文字分
```

## LICENSE
MIT

## thanks to
下記を参考にし、改変しました。
[raccy / japanese-wrap](https://github.com/raccy/japanese-wrap)

<japanese-wrap>
Copyright(c) 2014-2015 IGARASHI Makoto
https://raw.githubusercontent.com/raccy/japanese-wrap/master/LICENSE.md
