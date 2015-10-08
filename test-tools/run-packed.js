var jpWrap = require('../dist/jp-wrap.packed.js');

var str = '今後isomorphic JSは、universal JSと呼ぶといい、とのこと。'

try {
    var expected = '今後isomorphic JS\nは、universal JSと呼\nぶといい、とのこと。'
    console.assert(jpWrap(20)(str) == expected);
    console.log('pack test \033[32m[OK]\033[0m')
}
catch (e) {
    console.log('pack test \033[31m[NG]\033[0m')
}
