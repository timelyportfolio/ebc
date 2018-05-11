<template>
  <div class="col-md-9 ml-md-auto" style="padding-left: 50px;">
    <keep-alive>
      <router-view :filtered="filtered" :checkedfilters="checkedfilters"></router-view>
    </keep-alive>
  </div>
</template>

<script>
export default {
  props: ["filtered", "checkedfilters"]
}
</script>
