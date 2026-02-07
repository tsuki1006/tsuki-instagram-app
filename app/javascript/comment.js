import $ from 'jquery'
import axios from 'modules/axios'

const appendNewComment = (comment) => {
  $('.comments_list').append(
    `
    <li class="comment">
      <div class="comment_avatar">
        <img src="${comment.avatar_url}" class="avatar_s">
      </div>
      <div class="comment_text">
        <div class="comment_name">${comment.user_name}</div>
        <p  class="comment_content">${comment.content}</p>
      </div>
    </li>
    `
  )
}

document.addEventListener('turbo:load', () => {

  const articleId = $('#article').data('articleId')

  // 全てのコメントを表示
  axios.get(`/articles/${articleId}/comments.json`)
    .then((res) => {
      const comments = res.data
      comments.forEach((comment) => {
        appendNewComment(comment)
      })
    })

  // コメント追加
  $('#comment_content').on('keydown', function(e) {
    if(e.key == 'Enter') {

      // コメント取得
      const content = $(this).val()

      if (!content) {
        window.alert('コメントを入力してください');
      } else {

        // コメント送信
        axios.post(`/articles/${articleId}/comments.json`, {
          comment: { content: content }
        })
          // コメントを画面に追加
          .then((res) => {
            const comment = res.data
            appendNewComment(comment)
            $('#comment_content').val('')
          })

          .catch((e) => {
            window.alert(e.response.data.error)
            console.log(e)
            window.location.href = '/users/sign_in'
          })
      }
    }
  })
})