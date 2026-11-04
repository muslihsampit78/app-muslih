<?php

namespace App\Filament\Resources\QuestionTopics;

use App\Filament\Resources\QuestionTopics\Pages\CreateQuestionTopic;
use App\Filament\Resources\QuestionTopics\Pages\EditQuestionTopic;
use App\Filament\Resources\QuestionTopics\Pages\ListQuestionTopics;
use App\Filament\Resources\QuestionTopics\Schemas\QuestionTopicForm;
use App\Filament\Resources\QuestionTopics\Tables\QuestionTopicsTable;
use App\Models\QuestionTopic;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class QuestionTopicResource extends Resource
{
    protected static ?string $model = QuestionTopic::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedTag;

    protected static UnitEnum|string|null $navigationGroup = 'Pertanyaan Masyarakat';

    protected static ?string $navigationLabel = 'Topik Pertanyaan';

    protected static ?string $modelLabel = 'Topik';

    protected static ?string $pluralModelLabel = 'Topik Pertanyaan';

    protected static ?int $navigationSort = 1;

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return QuestionTopicForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return QuestionTopicsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListQuestionTopics::route('/'),
            'create' => CreateQuestionTopic::route('/create'),
            'edit' => EditQuestionTopic::route('/{record}/edit'),
        ];
    }
}
