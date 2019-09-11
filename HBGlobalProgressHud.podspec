Pod::Spec.new do |s|
    s.name         = 'HBGlobalProgressHud'
    s.version      = '0.0.2'
    s.summary      = '全局使用的progress' 
    s.homepage     = "https://github.com/Natoto/HBGlobalProgressHud.git"
    s.license      = "MIT"
    s.authors      = { 'natoto' => '787486160@qq.com'}
    s.platform     = :ios,'7.0'
    s.source       = { :git => "https://github.com/Natoto/HBGlobalProgressHud.git", :tag => s.version }
    s.source_files = "src/**/*.{h,m}" 
    s.requires_arc = true 
   
end
