<template>
  <div class="container" style="margin-top: 2em;">
    <div class="row align-items-start justify-content-center">
      <div class="col-10">
        <h3>Evidence for conservation</h3>
        <p>
          Global conservation initiatives are faced with a dual challenge: conserving natural ecosystems
          while improving human well-being. Achieving co-benefits for ecosystems, species, 
          and human communities will require robust evidence on what works, when, and how.
        </p>
        <p>
          The volume of data and research on conservation is a valuable asset to those seeking to pursue
          evidence-informed practice. Evidence synthesis methods are a “gold standard” for gleaning
          actionable insights from research in a transparent, comprehensive and unbiased manner.
          Syntheses are a critical tool for providing reliable and up-to-date information for decision-makers.
        </p>
      </div>
    </div>
    <div class="jumbotron-fluid jumbo-rice row align-items-center justify-content-center" style="height:350px;">
      <div class="col-9 standout-description">
        <h3>Purpose of this data portal</h3>
        <p>
          The Evidence for Nature and People Data Portal is an open access online knowledge
          management tool designed to help users explore the existing evidence on linkages
          between nature and people from published evidence syntheses. This portal allows users
          to access interactive dashboards that visualize patterns and trends in evidence
          synthesis datasets and customize to their needs.
        </p>
      </div>
    </div>
    <div class="row align-items-start justify-content-center">
      <div class="col-10">
        <h3>Tips and advice</h3>
        <p>
          We encourage users to read about how this data is generated and how to use the tool in
          the UNDERSTAND tab above. Users can explore data from different published syntheses in the EXPLORE tab.
        </p>
        <p>
          More information and how-to guides and videos can be found in the Tool section in the UNDERSTAND tab.
        </p>
        <p>
          We are constantly developing and improving upon this portal to suit the needs of our users.
          If you would like to provide feedback, please fill out this form. If you have questions,
          please reach out to us via the Contact link.
        </p>
      </div>
    </div>
    <div class="jumbotron-fluid jumbo-kid row align-items-center justify-content-center" style="height:300px;">
      <div class="col-9 standout-description">
        <h3>Share your data</h3>
        <p>
          If you are interested in having your evidence synthesis data hosted on this portal,
          please contact our team: admin@natureandpeopleevidence.org.
        </p>
      </div>
    </div>
    <div class="jumbotron-fluid jumbo-sponsor row align-items-start justify-content-center" style="max-height:270px; padding-bottom:20px;">
      <div class="col-10">
        <div class="row justify-content-center">
          <h4 class="text-center" style="margin-bottom:-10px; color:#eec919;">OUR PARTNERS</h4>
        </div>
        <div class="row align-items-center justify-content-center">
          <div class="col-4">
            <img src="../assets/ci_logo.png" style="width:100%;">
          </div>
          <div class="col-4">
            <img src="../assets/snap-acronym-color-white.png" style="width:100%;">
          </div>
          <div class="col-2">
            <img src="../assets/profor.png" style="width:100%;">
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: ["fulldata", "profordata"],
  beforeRouteEnter (to, from, next) {
    next(vm => vm.$emit("minimizeBanner", false))
  }
}
</script>

<style>
  h3 {
    color: #1f555f;
  }

  .standout-description {
    background-color: #383838;
    opacity: 0.85;
    max-height:75%;
    padding: 50px;
    overflow:auto;
  }

  .standout-description p {
    color: white;
  }

  .standout-description h3{
    color: #1a7a95;
  }

  
  .jumbo-rice {
    background-image: url('../assets/CI_ricepaddy.png');
    background-repeat: no-repeat;
    background-position: 0% 65%;
    background-size: cover;
    margin-bottom: 20px;
    padding-top: 0px;
    border-radius: 0px;
    background-color: rgb(131,146,143);
  }

  .jumbo-kid {
    background-image: url('../assets/kid-background.jpg');
    background-repeat: no-repeat;
    background-position: 0% 35%;
    background-size: cover;
    margin-bottom: 2px;
    padding-top: 0px;
    border-radius: 0px;
    background-color: rgb(131,146,143);
  }

  .jumbo-sponsor {
    background-color: #484446;
    background-repeat: no-repeat;
    background-position: 0% 35%;
    background-size: cover;
    margin-top: 100px;
    margin-bottom: 20px;
    padding-top: 0px;
    border-radius: 0px;
  }

</style>

<style scoped>
  h4 {
    margin: 1.5em 0;
  }

  .video-responsive {
    overflow: hidden;
    padding-bottom: 56.25%;
    position: relative;
    height: 0;
  }

  .video-responsive iframe{
      left: 0;
      top: 0;
      height: 100%;
      width: 100%;
      position: absolute;
  }
</style>