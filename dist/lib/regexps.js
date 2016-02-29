var CharacterClasses;

CharacterClasses = require('./character-classes');

module.exports = {
  notStartingChars: new RegExp(['[', CharacterClasses['Closing brackets'], CharacterClasses['Hyphens'], CharacterClasses['Dividing punctuation marks'], CharacterClasses['Middle dots'], CharacterClasses['Full stops'], CharacterClasses['Commas'], CharacterClasses['Iteration marks'], CharacterClasses['Prolonged sound mark'], CharacterClasses['Small kana'], ']'].join('')),
  notEndingChars: new RegExp(['[', CharacterClasses['Opening brackets'], ']'].join('')),
  notStartingCharsHalf: new RegExp(['[', CharacterClasses['Closing brackets'], CharacterClasses['Hyphens'], CharacterClasses['Dividing punctuation marks'], CharacterClasses['Middle dots'], CharacterClasses['Full stops'], CharacterClasses['Commas'], CharacterClasses['Iteration marks'], CharacterClasses['Prolonged sound mark'], CharacterClasses['Small kana'], CharacterClasses['Closing brackets HANKAKU'], CharacterClasses['Middle dots HANKAKU'], CharacterClasses['Full stops HANKAKU'], CharacterClasses['Commas HANKAKU'], CharacterClasses['Prolonged sound mark HANKAKU'], CharacterClasses['Small kana HANKAKU'], ']'].join(''))
};
