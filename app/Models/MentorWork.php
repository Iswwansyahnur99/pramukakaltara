<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MentorWork extends Model
{
    use HasFactory;
    protected $table = 'mentor_works';
    protected $fillable = ['photo', 'title', 'slug', 'content', 'user_id', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
