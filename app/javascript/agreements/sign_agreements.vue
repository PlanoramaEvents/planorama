<template>
  <b-modal id='agreements-modal' size="lg"
           hide-header-close no-close-on-backdrop no-close-on-esc
           :title="title" @ok="okAction"
           ok-title="I Agree" cancel-title="I Refuse">
    <div class="agreements-terms">
      <slot name="terms">{{terms}}</slot>
    </div>
    <div>
      <footer class="modal-footer">
        <slot name="footer">
          <p>By clicking ‘Agree’ below I do hereby agree to abide by the above usage restrictions. I acknowledge that there may be personal, business, and legal implications if I use this system inappropriately.</p>
        </slot>
        <button
            type="button"
            class="btn-green"
            @click="close"
        >
          Close Modal
        </button>
      </footer>
    </div>
  </b-modal>
</template>


<script>
import personSessionMixin from '../auth/person_session.mixin';
import {http as axios} from '../http';
var signedAgreements={};

export default {
  name: "SignAgreements",
  mixins: [personSessionMixin],
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
    okAction() {
      signedAgreements[this.ua]=true;
      //TODO: http://localhost:3000/agreement/sign/{{agreement-id}}
      axios.put('/agreement/sign/'+this.ua);
      setTimeout(() => { this.check_signatures(); }, 500);
    },
    close() {
      alert('modal closed')
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
