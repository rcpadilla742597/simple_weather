const express = require('express')

const app = express()


var fs = require('fs');

let x = []
let rawdata = fs.readFileSync('city.json');
let city = JSON.parse(rawdata);
for (var i = 0; i < city.length; i++) { // the plainest of array loops
    var obj = city[i];
    // for..in object iteration will set the key for each pair
    // and the value is in obj[key]
    x.push(obj['name'])

}
// console.log(x.length)



app.get('/', (req, res) => {
  if(x.indexOf("Tampa") !== -1)  
  {  
          res.send("Yes, the value exists!")  
  }   
  else  
  {  
          res.send("No, the value is absent.")  
  }



})

// export 'app'
module.exports = app