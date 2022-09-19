import consumer from "./consumer"

document.addEventListener('turbolinks:load', function() {
  gon.question_id = $('.question').data('questionId')
  if (this.answer_subscription) {
    consumer.subscriptions.remove(this.answer_subscription);
    this.subscription = null
    console.log("unsubing");
  }
  console.log(gon)

  if (gon.question_id ) {
    var answer_subscription =  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    // Called when the subscription is ready for use on the server.
    connected() {
      this.perform("follow")
      console.log("Connected to some channel", this);
    },

    received(data) {
      const empty_answers_node = $('.no_answers')
      if ( empty_answers_node.length > 0) { empty_answers_node.remove() }

      if(gon.user_id !== data.user_id && gon.question_id == data.question_id) {
        console.log(data.body)
        $('.answers-list').append('<p>' + data.answer + '</p>');
      }
    }
  });

  this.answer_subscription = answer_subscription;
}
})
