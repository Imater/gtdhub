'use strict'

angular.module('gtdhubApp').controller 'BlogCtrl', ($scope, Auth, $timeout) ->

  $scope.isAdmin = Auth.isAdmin

  $scope.startEdit = (el, article) ->
    articleHtml = $(el.target).parents('.article-wrap:first').find('.article-html')
    articleHtml.animate {'margin-top': '67px'}, 500, ()->
      $scope.$apply ()->
        article.edit = true
        $timeout ()->
          articleHtml.css('margin-top', '0px')
          article.editShow = true
        , 100
    return

  $scope.finishEdit = (el, article) ->
    console.info 'fin'
    article.editShow = false
    $timeout ()->
      article.edit = false
    , 50
    return


  $scope.filterBlogTreeMenu = {
    title: "All blog"
    cnt: 23
    childs: [
      title: 'CoffeeScript'
      cnt: 5
    ,
      title: 'Angular'
      cnt: 6
      childs: [
        title: 'Directives'
        cnt: 4
      ,
        title: 'Filters'
        cnt: 1
      ,
        title: 'Services'
        cnt: 2
      ,
        title: 'UI Router'
        cnt: 3
      ]
    ,
      title: 'HTML'
      cnt: 12
    ]
  }

  $scope.articles = [
    title: 'IXION — новый концепт «прозрачного» самолета'
    html: '''
        <p>
          Ну раз уж пятница, то можно и помечтать, хотя это будущее не так уж далеко, как кажется на первый взгляд. Парижская дизайнерская студия Technicon Design недавно победила в конкурсе <a href="http://thedesignawards.co.uk/yachtandaviation/">Yacht &amp; Aviation Award</a> с их проектом IXION Windowless Jet Concept. Идея заключается в панорамной съемке внешними камерами самолета и отображении этой картинки на мониторах с высоким разрешением, которые вмонтированы в стены и потолок самолета.
        </p>
        <p>
          <img src="app/uploads/1.jpg" style="font-size: 13px; color: rgb(0, 0, 0); font-family: Verdana, sans-serif; background-color: rgb(255, 255, 255);"><br>
          <a href="http://blog.technicondesign.com/2014/05/technicon-design-france-team-received.html">пресс-релизе</a> директор департамента дизайна Гарэт Дэвис.
        </p>
        <p>
          Фотографии концепта
        </p>
        <p>
          <br>
          Но Technicon Design, конечно же, не первые пришли на рынок с этой идеей. Ранее в 2012 году на Парижском авиашоу Airbus уже<a href="https://www.youtube.com/watch?v=9OsOFZCwlT8">презентовал</a> концепт пассажирского авиалайнера с вмонтированными мониторами по всему салону. А бостонская компания Spike Aerospace пошла еще дальше и уже создает такой джет <a href="http://www.spikeaerospace.com/s-512-supersonic-jet/">S-512</a>, который будет курсировать по маршруту Лондон &mdash; Нью-Йорк со скоростью 1'770 км/час и перевозить на борту до 18 пассажиров. Начало продаж S-512 запланировано на декабрь 2018 года, предварительная стоимость £48'000'000.
        </p>
    '''
  ,
    title: 'Новость дня'
    html: '''
        <p>
          Ну раз уж пятница, то можно и помечтать, хотя это будущее не так уж далеко, как кажется на первый взгляд. Парижская дизайнерская студия Technicon Design недавно победила в конкурсе <a href="http://thedesignawards.co.uk/yachtandaviation/">Yacht &amp; Aviation Award</a> с их проектом IXION Windowless Jet Concept. Идея заключается в панорамной съемке внешними камерами самолета и отображении этой картинки на мониторах с высоким разрешением, которые вмонтированы в стены и потолок самолета.
        </p>
        <p>
          <img src="app/uploads/1.jpg" style="font-size: 13px; color: rgb(0, 0, 0); font-family: Verdana, sans-serif; background-color: rgb(255, 255, 255);"><br>
          <a href="http://blog.technicondesign.com/2014/05/technicon-design-france-team-received.html">пресс-релизе</a> директор департамента дизайна Гарэт Дэвис.
        </p>
        <p>
          Фотографии концепта
        </p>
        <p>
          <br>
          Но Technicon Design, конечно же, не первые пришли на рынок с этой идеей. Ранее в 2012 году на Парижском авиашоу Airbus уже<a href="https://www.youtube.com/watch?v=9OsOFZCwlT8">презентовал</a> концепт пассажирского авиалайнера с вмонтированными мониторами по всему салону. А бостонская компания Spike Aerospace пошла еще дальше и уже создает такой джет <a href="http://www.spikeaerospace.com/s-512-supersonic-jet/">S-512</a>, который будет курсировать по маршруту Лондон &mdash; Нью-Йорк со скоростью 1'770 км/час и перевозить на борту до 18 пассажиров. Начало продаж S-512 запланировано на декабрь 2018 года, предварительная стоимость £48'000'000.
        </p>
    '''
  ,
    title: 'Третья но'
    html: '''
        <p>
          Ну раз уж пятница, то можно и помечтать, хотя это будущее не так уж далеко, как кажется на первый взгляд. Парижская дизайнерская студия Technicon Design недавно победила в конкурсе <a href="http://thedesignawards.co.uk/yachtandaviation/">Yacht &amp; Aviation Award</a> с их проектом IXION Windowless Jet Concept. Идея заключается в панорамной съемке внешними камерами самолета и отображении этой картинки на мониторах с высоким разрешением, которые вмонтированы в стены и потолок самолета.
        </p>
        <p>
          <img src="app/uploads/1.jpg" style="font-size: 13px; color: rgb(0, 0, 0); font-family: Verdana, sans-serif; background-color: rgb(255, 255, 255);"><br>
          <a href="http://blog.technicondesign.com/2014/05/technicon-design-france-team-received.html">пресс-релизе</a> директор департамента дизайна Гарэт Дэвис.
        </p>
        <p>
          Фотографии концепта
        </p>
        <p>
          <br>
          Но Technicon Design, конечно же, не первые пришли на рынок с этой идеей. Ранее в 2012 году на Парижском авиашоу Airbus уже<a href="https://www.youtube.com/watch?v=9OsOFZCwlT8">презентовал</a> концепт пассажирского авиалайнера с вмонтированными мониторами по всему салону. А бостонская компания Spike Aerospace пошла еще дальше и уже создает такой джет <a href="http://www.spikeaerospace.com/s-512-supersonic-jet/">S-512</a>, который будет курсировать по маршруту Лондон &mdash; Нью-Йорк со скоростью 1'770 км/час и перевозить на борту до 18 пассажиров. Начало продаж S-512 запланировано на декабрь 2018 года, предварительная стоимость £48'000'000.
        </p>
    '''

  ]