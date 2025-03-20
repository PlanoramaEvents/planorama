<template>
  <b-modal id='agreements-modal' size="lg"
         hide-header-close no-close-on-backdrop no-close-on-esc
         :title="title" @ok="onAgree" @cancel="onRefuse"
         ok-title="I Agree" cancel-title="I Refuse">
    <div class="agreements-terms" v-html="terms"></div>
    <div>
      <footer class="modal-footer">
        <p>By clicking ‘Agree’ below I do hereby agree to abide by the above usage restrictions. I acknowledge that there may be personal, business, and legal implications if I use this system inappropriately.</p>
      </footer>
    </div>
  </b-modal>
</template>


<script>
import personSessionMixin from '@/auth/person_session.mixin';
import authMixin from '@/auth/auth.mixin';
import {http as axios} from '@/http';
let signedAgreements={};

export default {
  name: "SignAgreements",
  mixins: [personSessionMixin, authMixin],
  data() {
    return {
      ua:'',
      terms:'',
      title:''
    }
  },
  methods: {
    check_signatures() {
      for (this.ua in this.currentUser.unsigned_agreements) {
        if(!signedAgreements[this.ua]) {
          this.title=this.currentUser.unsigned_agreements[this.ua].title;
          this.terms=this.currentUser.unsigned_agreements[this.ua].terms;
          this.$bvModal.show('agreements-modal');
          break;
        }
      }
    },
    onAgree() {
      signedAgreements[this.ua]=true;
      axios.put('/agreement/sign/'+this.ua);
      setTimeout(() => { this.check_signatures(); }, 500);
    },
    onRefuse() {
      this.signOut().finally(() => {
        window.location.href="/";
      });
    }
  }
}
</script>

<style>
.agreements-terms {
  max-height: 50vh;
  overflow-y: auto;
}
</style>
