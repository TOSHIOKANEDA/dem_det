// Wan HaiとTSLのみで使用する[DEM ONLY]東京港/大阪港のみを制御する
$(function () {
  $(".carrier_name").change(function(){
    var carrier = $(".carrier_name").val()
    console.log(carrier)
    var option_wanhai = `<option id="optional">[DEM ONLY]東京港/大阪港のみ</option>`
    if (carrier == 2){
      $('p .port').append(option_wanhai)
    } else {
      $('p #optional').remove()
    }

    if (carrier == 6) {
      $('p .cntr_type option[value=6]').text("20FT OpenTop（Ingage）")
      $('p .cntr_type option[value=7]').text("40FT OpenTop（Ingage）")
      $('p .cntr_type option[value=8]').text("20FT FlatRack（Ingage）")
      $('p .cntr_type option[value=9]').text("40FT FlatRack（Ingage）")
    } else {
      $('p .cntr_type option[value=6]').text("20FT OpenTop")
      $('p .cntr_type option[value=7]').text("40FT OpenTop")
      $('p .cntr_type option[value=8]').text("20FT FlatRack")
      $('p .cntr_type option[value=9]').text("40FT FlatRack")
    }
  })
});
