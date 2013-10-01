get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/:handle' do
  if @user = User.find_by_username(params[:handle])
    if Time.now - @user.tweets.first.created_at > 900
      @user.tweets.destroy_all
      tweets = Twitter.user_timeline(params[:handle],:count => 10, :include_rts => false)
      @tweets = []
      tweets.each { |tweet| @tweets << Tweet.create(user_id: @user.id, text: tweet.text, created_at: Time.now) }
      if request.xhr?
        erb :tweets, layout: false
      end
    else
      @tweets = @user.tweets.limit(10)
      erb :tweets, layout: false
    end
  else
    @user = User.create(username: params[:handle])
    tweets = Twitter.user_timeline(params[:handle],:count => 10, :include_rts => false)
    @tweets = []
    tweets.each { |tweet| @tweets << Tweet.create(user_id: @user.id, text: tweet.text, created_at: Time.now) }
    if request.xhr?
      erb :tweets, layout: false
    end
  end
  erb :tweets, layout: false
end

post '/' do 
  redirect to("/#{params[:handle]}")
end
