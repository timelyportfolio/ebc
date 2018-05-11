<template>
  <nav class="navbar navbar-expand-md">
    <ul class="nav">
      <li class="nav-item">
        <router-link class="nav-link" active-class="active" to="charts">Visualization</router-link>
      </li>
      <li class="nav-item">
        <router-link class="nav-link" active-class="active" to="tables">Table</router-link>
      </li>
      <li class="nav-item">
        <router-link class="nav-link" active-class="active" to="download">Download</router-link>
      </li>
      <li class="nav-item">
        <router-link class="nav-link" active-class="active" to="about">About</router-link>
      </li>
    </ul>
  </nav>
</template>

<style scoped>
  .navbar {
    background-color: #ddd;
    margin-top: 4px;
    margin-left: -10px;
    margin-right: -10px;
  }

  .nav-link.active {
    border-bottom: 1px #bbb solid;
  }
</style>
