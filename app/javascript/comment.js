import $ from 'jquery'
import axios from 'modules/axios'

document.addEventListener('turbo:load', () => {

  // コメント追加
  $('#comment_content').on('keydown', function(e) {
    if(e.key == 'Enter') {

      // コメント取得
      const content = $(this).val()

      if (!content) {
        window.alert('コメントを入力してください');
      } else {

        // コメント送信
        const articleId = $('#article').data('articleId')
        axios.post(`/articles/${articleId}/comments`, {
          comment: { content: content }
        })
          // コメントを画面に追加
          .then((res) => {
            const comment = res.data
            console.log(res)

            $('.comments_list').append(
              `
              <li class="comment">
                <div class="comment_author">
                  <img src="${comment.avatar_url}">
                  <div>${comment.user_name}</div>
                </div>
                <p>${comment.content}</p>
              </li>
              `
            )
            $('#comment_content').val('')
          })

          .catch((e) => {
            window.alert('Error')
            console.log(e)
          })
      }
    }
  })
})