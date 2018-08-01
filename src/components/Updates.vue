<template>
  <div class="container-fluid" style="margin-top: 2em;">
  
    <div class="row align-items-center justify-content-center" style="margin-bottom: 50px;">
  
      <div class="col-10">
  
        <h3>Updates &amp; News</h3>

        <div class="col-10">
          <div class="row post" v-for="(entry, i) in posts">
            <h4>{{entry.gsx$title.$t}}</h4>
            <div class="content" v-html="entry.gsx$body.$t"></div>
          </div>
        </div>
   
      </div>

    </div>

  
    <div class="row align-items-center justify-content-center" style="margin-bottom: 50px;">
    </div>
  </div>
</template>

<script>
  import axios from 'axios'

  export default {
    data: function () {
      return {
        posts: null
      }
    },
    created: function() {
      axios.get('https://spreadsheets.google.com/feeds/list/1Rc-cPPV75zMOzOewdg2NhxXvIIphW13dK6EtgHL3bCE/1/public/values?alt=json').then(response => {
        this.posts = response.data.feed.entry
      })
      .catch(e => {
        console.log('error getting data', e)
        //this.errors.push(e)
      })
    },
    beforeRouteEnter (to, from, next) {
      next(vm => vm.$emit("minimizeBanner", true))
    },
    beforeRouteLeave (to, from, next) {
      this.$emit("minimizeBanner", false)
      next()
    }
  }
</script>


<style scoped>
  .row.post {
    padding: 25px;
  }
  .row.post:nth-child(odd) h4 {
    color:rgb(0, 102, 153)
  }
  .row.post:nth-child(even) {
    background-color:#383838;
    color: white;
  }
  .row.post:nth-child(even) h4 {
    color: rgb(238, 201, 25);
  }
</style>
