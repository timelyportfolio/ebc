<template>

  <div class="container" style="margin-top: 2em;">
    <div class="row align-items-start justify-content-center">
      <div class="col col-8">
        <div style="color:#006699">
          <h2 align="center">
            <strong>ABOUT THE DATA &amp; TOOL</strong>
          </h2>
        </div>
      </div>
    </div>

    <div class="row align-items-start justify-content-center">
      <div class="col col-8">
        <ul class="nav nav-tabs" role="tablist">
          <li class="nav-item">
            <router-link class="nav-link" to="/about/tool/data" active-class="active" role="tab">The Data</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/about/tool/tool" active-class="active" role="tab">The Tool</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/about/tool/glossary" active-class="active" role="tab">Glossary</router-link>
          </li>      
        </ul>
      </div>
    </div>

    <div class = "tab-content">
      <div class="row align-items-start justify-content-center">
        <div class="col col-8">
          <router-view></router-view>
        </div>
      </div>
    </div>
  </div>

</template>