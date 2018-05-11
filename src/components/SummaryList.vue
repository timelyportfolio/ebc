<template>
  <ul class="list-group list-group-flush">
    <li class="list-group-item d-flex justify-content-between align-items-center" v-for="item in items">
      {{item.title}}
      <span class="badge badge-primary badge-pill">{{item.number}}</span>
    </li>
  </ul>
</template>

<script>
export default {
  props: ["items"]
}
</script>

<style scoped>
  .list-group-item {
    padding: 0.25rem 0.5rem;
  }
</style>
