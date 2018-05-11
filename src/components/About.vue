<template>
  <router-view></router-view>
</template>

<script>

export default {
  beforeRouteEnter (to, from, next) {
    next(vm => vm.$emit("minimizeBanner", true))
  }
}
</script>