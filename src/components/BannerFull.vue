<template>
  <div class = "jumbotron banner-portal banner">
    <div class="row align-items-center alternate-row" style="background-color:#383838;padding:20px;">
      <div class="col col-md-8" align="left">
        <!--div class="hcon"-->
          <h1>
            <router-link to="/" style="color:white; text-decoration: none;">EVIDENCE FOR NATURE AND PEOPLE</router-link>
          </h1>
          <div style="color: #1a7a95; font-size:30px">
              <em>DATA PORTAL</em>
          </div>
        <!--/div-->
      </div>
      <div class="col col-md-3" align="right">
        <router-link to="/about/group" style="color:#eec919; font-size:1.5em; padding-right:20px; text-decoration:none;">
          ABOUT
        </router-link>
        <router-link to="/contact" style="color:#eec919; font-size:1.5em; text-decoration:none;">CONTACT</router-link>
      </div>
    </div>
    <div class="row align-items-start justify-content-center">
      <div class="col-sm-3 text-center">
        <div class="dropdown">
          <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownUnderstandButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            UNDERSTAND
          </button>
          <div class="dropdown-menu text-center" aria-labelledby="dropdownUnderstandButton">
            <router-link to="/about/method" class="dropdown-item">Evidence Synthesis</router-link>
            <a class="dropdown-item" href="#">Portal & Tool</a>
          </div>
        </div>
      </div>
      <div class="col-sm-3 text-center">
        <div class="dropdown">
          <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownExploreButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            EXPLORE THE DATA
          </button>
          <div class="dropdown-menu text-center" aria-labelledby="dropdownExploreButton">
            <router-link to="/explore/wellbeing" class="dropdown-item">Conservation &<br/>Human Well-Being</router-link>
            <router-link to="/explore/wildlife" class="dropdown-item">Effectiveness of international<br/>wildlife trade programs</router-link>
            <router-link to="/explore/profor" class="dropdown-item">Contribution of forests<br/>to poverty alleviation</router-link>
          </div>
        </div>
      </div>
      <div class="col-sm-3 text-center">
        <a class="btn btn-secondary" href="#" role="button">
          UPDATES & NEWS
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {

}
</script>

<style scoped>
  button.btn-secondary, a.btn {
    background-color: #047a7a;
    border: none;
    border-radius: 0px;
    color: white;
    font-family: 'Myriad Pro Condensed', 'PT Sans Narrow';
    font-size: 1.25em;
  }

  button.btn-secondary:active, .show>.btn-secondary.dropdown-toggle {
    background-color: #047a7a;
    color: white;
  }

  .dropdown-menu {
    background-color: #ffffff00;
    border: none;
    border-radius: 0px;
  }

  .dropdown-item {
    background-color: #c9a827;
    margin-bottom: 5px;
  }

  .dropdown-item:hover {
    background-color:#fff;
    border: 1px #c9a827 solid;
  }

  .dropdown-item:active {
    color: black;
    top: 1px;
  }
</style>
