<template>
  <div id="app" class="container-fluid">
    <banner :minimal="minimalbanner"></banner>
    <!--nav class="navbar navbar-toggleable-sm navbar-light nb-main" role="navigation">
      <div class = "container">
        <div class="navbar-header" style="width:130px;">
          <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#nb-main-collapse" aria-controls="navbarSupportedContentMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <router-link to="/" class="navbar-brand">Home</router-link>
        </div>
        <div class="collapse navbar-collapse" id="nb-main-collapse">
          <ul class="navbar-nav mr-auto">
            <li class="nav-item dropdown">  
              <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">ABOUT</a>
              <div class="dropdown-menu">
                <router-link to="/about/method" class="dropdown-item">The Method</router-link>
                <router-link to="/about/tool" class="dropdown-item">The Data &amp; Tool</router-link>
                <router-link to="/about/group" class="dropdown-item">The Group</router-link>
              </div>
            </li>
            <li class="nav-item dropdown">  
              <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">EXPLORE BY</a>
              <div class="dropdown-menu">
                <router-link to="/explore/wellbeing" class="dropdown-item">Human Well-Being</router-link>
                <router-link to="/explore/profor" class="dropdown-item">Program on Forests</router-link>
              </div>
            </li>
            <li class="nav-item">
              <router-link to="/news" class="nav-link">NEWS</router-link>
            </li>
            <li class="nav-item dropdown">  
              <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">RESEARCH</a>
              <div class="dropdown-menu">
                <router-link to="/research/ongoing" class="dropdown-item">Ongoing syntheses/maps</router-link>
              </div>
            </li>
            <li class="nav-item">
              <router-link to="/contact" class="nav-link">CONTACT</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/register" class="nav-link">USER REGISTRATION</router-link>
            </li>
          </ul>

        </div>
      </div>
    </nav-->

    <div class="container-fluid">
      <keep-alive>
        <router-view
         :fulldata="fulldata"
         :profordata="profordata"
         @minimizeBanner = "changeBannerSize"
        ></router-view>
      </keep-alive>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Banner from './components/Banner.vue'

export default {
  name: 'app',
  components: {Banner},
  data: function () {
    return {
      fulldata: [],
      profordata: [],
      minimalbanner: false
    }
  },
  created: function() {
    axios.get('./static/data.json').then(response => {
      this.fulldata = response.data
    })
    .catch(e => {
      console.log('error getting data', e)
      //this.errors.push(e)
    })
    axios.get('./static/data_profor.json').then(response => {
      this.profordata = response.data
    })
    .catch(e => {
      console.log('error getting data', e)
      //this.errors.push(e)
    })
  },
  methods: {
    changeBannerSize: function (minimal) {
      this.minimalbanner = minimal
    }
  }
}
</script>

<style>
  @import url("https://fonts.googleapis.com/css?family=PT+Sans|PT+Sans+Narrow");
  body {
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-size: 15px;
    line-height: 1.42857143;
  }

  .portal-data, h3, h4 {
    font-family: 'Myriad Pro Regular', 'PT Sans', sans-serif;
  }

  .banner-portal {
    min-height: 375px;
    background-image: url('./assets/header3.jpg');
    background-repeat: no-repeat;
    background-position: 0% 55%;
    background-size: cover;
    margin-bottom: 0px;
    margin-right: -30px;
    margin-left: -30px;
    padding-top: 0px;
    border-radius: 0px;
    background-color: rgb(131,146,143);
  }

  .banner-portal .hcon {
    background-color: rgba(0, 0, 0, 0.5);
    padding: 20px;
    margin-top: 20px;
  }

  .banner-portal .hcon h1 {
    color: #fff;
    margin-bottom: 20px;
  }

  .nb-main {
    background-color: #44CDB5;
    font-size: 90%;
  }
  .nb-main > .container > .navbar-header  .navbar-brand, #nb-main-collapse > ul a  {
    color: #fff;
  }
  #nb-main-collapse .dropdown-menu > a {
    color: #7b8a8b;
  }
</style>