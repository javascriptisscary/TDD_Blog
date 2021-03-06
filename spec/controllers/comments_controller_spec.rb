require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  
  context "No User logged in" do
    before do
      @post = create(:post)
    end
  
    describe "POST #create" do
      it "redirects to new user session" do  
        post :create, comment: FactoryGirl.attributes_for(:comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    describe "DELETE #destroy" do
       it "deletes the post" do  
          delete :destroy, {user_id: @post.user,  id: @post.id}
          expect(response).to redirect_to(new_user_session_path)  
       end
     end
    
  
  end #end user not logged in
  
  
  
  context "User logged in" do
    before do
        @user = create(:user)
        sign_in @user
        @post = create(:post, user: @user)
        @com_attr = FactoryGirl.attributes_for(:comment, post_id: @post.id, user_id: @user.id)
        
        @comment = create(:comment, user: @user, post: @post)
        
        @post1 = create(:post, user_id: @user.id)
        @user1 = create(:user)
        @comment1 = create(:comment, user_id: @user1.id, post_id: @post1.id)
        @comment2 = create(:comment, user: @user1, post: @post1)
        @admin = create(:user, admin: true)
      end
  
  
    describe "Post#create" do
      
      
      it "create a comment" do
        expect {
           post :create,  { comment: @com_attr}
         }.to change(Comment, :count).by(1)
      end
    
    end
  
  
    describe "DELETE #destroy" do
        
      it "user deletes own comment" do  
        expect {
          delete :destroy, {user_id: @user, id: @comment.id}
        }.to change(Comment, :count).by(-1) 
       end
     end
  
  
  
  
  context " user is admin" do
    before do
      @admin = create(:user, admin: true)
      sign_in @admin
    end
  
    it "will let admin destroy different user's post" do
      expect {
        delete :destroy, {id: @comment2.id}
      }.to change(Comment, :count).by(-1) 
    end
  end
  
  
  
  end #end user logged in




end
