// Wan HaiとTSLのみで使用する[DEM ONLY]東京港/大阪港のみを制御する
$(function () {
  $(".carrier_name").change(function(){
    var carrier = $(".carrier_name").val()
    var option = `<option id="optional">[DEM ONLY]東京港/大阪港のみ</option>`
    if (carrier == 2){
      $('p .port').append(option)
    } else {
      $('p #optional').remove()
    }
  })
});
