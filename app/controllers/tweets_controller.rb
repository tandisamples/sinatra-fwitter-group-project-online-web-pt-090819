class TweetsController < ApplicationController

    get '/tweets' do
        if is_logged_in?
            @tweets = Tweet.all 
            erb :'/tweets/tweets'
        else
            redirect to '/users/login'
        end
    end

    get '/tweets/new' do
        if !is_logged_in?
            redirect to "/login"
        else
            erb :"tweets/create_tweet"
        end
    end

    post '/tweets' do
        # user = current_user(session)
        # binding.pry
        if params[:tweet][:content].empty?
            redirect to "/tweets/new"
        end
        tweet = Tweet.create(:content => params[:tweet][:content], :user_id => current_user.id)
        redirect to "/tweets"
    end

    get '/tweets/:id' do
        redirect to "/login" unless is_logged_in?
        @tweet = Tweet.find_by(id: params[:id])
        erb :"/tweets/show_tweet"
    end

    get '/tweets/:id/edit' do
        redirect to "/login" unless is_logged_in?
        @tweet = Tweet.find_by(:id => params[:id])
        if @tweet.user == current_user
            erb :"/tweets/edit_tweet"
        else
            redirect to "/login"
        end
    end

    patch '/tweets/:id' do
        # binding.pry
        redirect to "/login" unless is_logged_in?
        @tweet = Tweet.find_by(:id => params[:id])
        if @tweet.user == current_user
            if @tweet.update(params[:tweet])
            redirect to "/tweets/#{@tweet.id}"
            else
                redirect to "/tweets/#{@tweet.id}/edit"
            end
        else
            redirect to "/tweets"
        end

    end

    delete '/tweets/:id' do
        redirect to "/login" unless is_logged_in?
        @tweet = Tweet.find_by(:id => params[:id])
        if @tweet.user == current_user
            @tweet.delete
        end
        redirect to "/tweets"
    end
end
