
$(function () {
  $('#start_cal').click(function () {
    $("h1").css("color", "#0000FF");
    var Start = $('.start');
    var Finish = $('.finish');
    var Calc = $('.calc')
    var Type = $('.cntr_type')
    var Free = $('.free_time')
    var Carrier = $('.carrier_name')
    var DemDet = $('.dem_det')
    var Port = $('.port')

    $.ajax({
      type: 'GET',
      url: '/carriers/search',
      data:  { 
        start: Start.val(),
        finish: Finish.val(),
        dem_det: DemDet.val(),
        calc: Calc.val(),
        type: Type.val(),
        free: Free.val(),
        carrier: Carrier.val(),
        port: Port.val()
      }, // サーバーに送信するデータ
      dataType: 'json' // サーバーから返却される型
    })

    .done(function (data) {
      $('.js-messages li').remove();
      $('.js-messages p').remove();
      $('.js-messages h2').remove();
      $('.js-messages').append(
        `
        <p>${data.carrier}タリフ（${data.type}・${data.dem_det}・港は${data.port}です。）</p>
        <li class="message">超過${data.first_range[0]}日〜${data.first_range[1]}日：${data.first_tariff}円</li>
        <li class="message">超過${data.second_range[0]}日〜${data.second_range[1]}日：${data.second_tariff}円</li>
        <li class="message">超過${data.third_range[0]}日〜${data.third_range[1]}日：${data.third_tariff}円</li>
        <li class="message">超過${data.fourth_range[0]}日〜：${data.fourth_tariff}円</li>
        <p>明細</p>
        <li class="message">フリータイム：${data.free_period[0]}〜${data.free_period[1]}</li>
        <li class="message">超過期間（１）${data.first_each_day[1]}日間（${data.first_each_day[0]}） x ${data.first_tariff}円 ＝ ${data.first_amount}円</li>
        <li class="message">超過期間（２）${data.second_each_day[1]}日間（${data.second_each_day[0]}） x ${data.second_tariff}円 ＝ ${data.second_amount}円</li>
        <li class="message">超過期間（３）${data.third_each_day[1]}日間（${data.third_each_day[0]}） x ${data.third_tariff}円 ＝ ${data.third_amount}円</li>
        <li class="message">超過期間（４）${data.fourth_each_day[1]}日間（${data.fourth_each_day[0]}） x ${data.fourth_tariff}円 ＝ ${data.fourth_amount}円</li>
        <h2>合計：${data.total_amount}円</h2>
        `
      );
    })

  });
});