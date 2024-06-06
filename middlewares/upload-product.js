const  multer = require('multer');

const storage = multer.diskStorage({
    destination: function(req, file, cb){
        cb(null, 'public/uploads/users');
    },
    filename: function(req, file, cb){
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = file.originalname.split('.')[file.originalname.split('.').length - 1];
        cb(null, uniqueSuffix + '.' + ext);
    }
});

const upload = multer({
    storage: storage,

    limits : { fileSize: 3 * 1024 * 1024 },
    
    fileFilter: function(req, file, cb){
        if(file.mimetype == "image/png" || file.mimetype == "image/jpg" || file.mimetype == "image/jpeg"){
            cb(null, true);
        }else{
            return cb(new Error('Only .png, .jpg and .jpeg format allowed!'));
        }
    }
    
});

module.exports = upload;