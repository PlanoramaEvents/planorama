<template>
  <div class="row">
    <div class="col-12">
      Be agreeable {{currentUser.name}}!
    </div>
    <!-- <AgreementsModal @close="isModalVisible = false"> -->
      <!--
        you can use custom content here to overwrite
        default content
      -->
      <!-- <template v-slot:title>{{currentUser.unsigned_agreements[ua].title}}</template>
    </AgreementsModal> -->
  </div>
</template>

<script>
import personSessionMixin from '../auth/person_session.mixin';
import AgreementsModal from "@/components/agreements_modal";

export default {
  name: "Agreements",
  components: {
    AgreementsModal,
  },

/*  updated(){
    //alert("in mounted: "+this.currentUser.name);
    for(const ua in this.currentUser.unsigned_agreements) {
      alert(ua+": "+signed_agreements[ua]);
      if(!signed_agreements[ua]) {
        alert(this.currentUser.unsigned_agreements[ua].title);
        this.bob=ua;
        this.isModalVisible=true;
        //this.$bvModal.show("my-modal");
        //this.$refs['my-modal'].show();
        signed_agreements[ua]=true;
        alert(ua+": "+signed_agreements[ua]);
      }
    }
  },*/
  mixins: [personSessionMixin],
  mounted() {
    console.debug("AGRREMENT MOUNTED")
  }
}
</script>

<style>

</style>
