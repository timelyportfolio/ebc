<template>
  <BannerFull v-if="minimal===false"></BannerFull>
  <BannerMinimal v-else></BannerMinimal>
</template>

<script>
  import BannerFull from './BannerFull.vue'
  import BannerMinimal from './BannerMinimal.vue'

  export default {
    components: {
      BannerFull,
      BannerMinimal
    },
    props: {
      minimal: {
        type: Boolean,
        default: () => true
      }
    }
  }
</script>

<style scoped>
  .banner {
    font-family: 'Myriad Pro Condensed', 'PT Sans Narrow';
  }
</style>
