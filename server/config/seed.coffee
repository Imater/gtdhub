###
Populate DB with sample data on server start
to disable, edit config/environment/index.js, and set `seedDB: false`
###
"use strict"
Thing = require("../api/thing/thing.model")
Article = require("../api/article/article.model")
User = require("../api/user/user.model")

Article.find({}). remove ->
  Article.create
    title: 'Новые солнечные самолёты IXION'
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
    date: new Date()
    active: true
  ,
    title: 'Типы данных в MongoDB'
    html: '''
<p>
	<strong>Schema.Types</strong>
</p>
<p>
	The various built-in Mongoose Schema Types.
</p>
<p>
	show code
</p>
<p>
	<strong>Example:</strong>
</p>
<p>
	<strong>var</strong> mongoose = require('mongoose');
</p>
<p>
	<strong>var</strong> ObjectId = mongoose.Schema.Types.ObjectId;
</p>
<p>
	<strong>Types:</strong>
</p>
<ul>
	<li>String</li>
	<li>Number</li>
	<li>Boolean | Bool</li>
	<li>Array</li>
	<li>Buffer</li>
	<li>Date</li>
	<li>ObjectId | Oid</li>
	<li>Mixed</li>
</ul>
<p>
	Using this exposed access to the Mixed SchemaType, we can use them in our schema.
</p>
<p>
	<strong>var</strong> Mixed = mongoose.Schema.Types.Mixed;
</p>
<p>
	<strong>new</strong> mongoose.Schema({ _user: Mixed })
</p>
    '''
    date: new Date()
    active: true

Thing.find({}).remove ->
  Thing.create
    name: "Development Tools"
    info: "Integration with popular tools such as Bower, Grunt, Karma, Mocha, JSHint, Node Inspector, Livereload, Protractor, Jade, Stylus, Sass, CoffeeScript, and Less."
  ,
    name: "Server and Client integration"
    info: "Built with a powerful and fun stack: MongoDB, Express, AngularJS, and Node."
  ,
    name: "Smart Build System"
    info: "Build system ignores `spec` files, allowing you to keep tests alongside code. Automatic injection of scripts and styles into your index.html"
  ,
    name: "Modular Structure"
    info: "Best practice client and server structures allow for more code reusability and maximum scalability"
  ,
    name: "Optimized Build"
    info: "Build process packs up your templates as a single JavaScript payload, minifies your scripts/css/images, and rewrites asset names for caching."
  ,
    name: "Deployment Ready"
    info: "Easily deploy your app to Heroku or Openshift with the heroku and openshift subgenerators"


User.find({}).remove ->
  User.create
    provider: "local"
    name: "Test User"
    email: "test@test.com"
    password: "test"
  ,
    provider: "local"
    role: "admin"
    name: "Admin"
    email: "admin@admin.com"
    password: "admin"
  , ->
    console.log "finished populating users"

